import Foundation
import Alamofire
import Combine
import Moya

typealias ParametersDictionary = [String: Any]

/// Provides methods to perform requests over Moya
class BaseAPIManager<T: TargetType> {
	enum DataField: String {
		case none			// No nested data field
		case data       	// Parse from "data" field
        case results        // Parse from "results" field
        case detail         // Parse from "detail" field
	}

	// MARK: - Properties

	/// Base URL built according to current environment
	static var basePath: String {
        return "http://streaming.nexlesoft.com:4000/"
	}

	/// Moya provider object
    private lazy var provider: MoyaProvider<T> = {
        let authPlugin = AccessTokenPlugin(tokenClosure: { [weak self] _ in
            self?.token.token ?? ""
        })
        
        let disableCookiePlugin = DisableCookiePlugin()

        var plugins: [PluginType] = [authPlugin, disableCookiePlugin]

        #if DEBUG
        let loggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.verbose]))
        plugins.append(loggerPlugin)
        #endif

        let configuration = URLSessionConfiguration.default

        var headers: [String: String] = HTTPHeaders.default.dictionary
        configuration.headers = HTTPHeaders(headers)

        let interceptor = APIRequestRetrier(token: token)

        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false, interceptor: interceptor)
        return MoyaProvider<T>(endpointClosure: self.endpointClosure, stubClosure: self.stubClosure, session: session, plugins: plugins)
    }()

    let token: Tokenable
    
    // Use this for testing purpose (or customize)
    private let endpointClosure: MoyaProvider<T>.EndpointClosure
    private let stubClosure: MoyaProvider<T>.StubClosure

    init(token: Tokenable,
         endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub) {
        self.endpointClosure = endpointClosure
        self.stubClosure = stubClosure
        self.token = token
    }
}

// MARK: - request APIs
extension BaseAPIManager {
    /// Handle request API with completion block
    @discardableResult
    func request<Model: Decodable>(target: T,
                                   type: Model.Type,
                                   dataField: DataField = .none,
                                   callbackQueue: DispatchQueue? = .none,
                                   progress: ProgressBlock? = .none,
                                   completion: @escaping (Result<Model, APIError>) -> Void) -> Moya.Cancellable {
        return provider.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            let result: Result<Model, APIError> = BaseAPIManager.mapResult(result, dataField: dataField)
            completion(result)
        }
    }

    // Handle request API with returned AnyPublisher
    func request<Model: Decodable>(target: T,
                                   callbackQueue: DispatchQueue? = .none,
                                   dataField: DataField = .data,
                                   progress: ProgressBlock? = .none) -> AnyPublisher<Model, APIError> {
        return Deferred {
            Future<Response, MoyaError> { [weak self] promise in
                self?.provider.request(target, callbackQueue: callbackQueue, progress: progress) { result in
                    promise(result)
                }
            }
        }
        .tryMap { try Self.mapResponse($0, dataField: dataField) }
        .mapError { Self.mapError($0) }
        .eraseToAnyPublisher()
    }
}

// MARK: - Helper methods

extension BaseAPIManager {
    /// Maps default Moya result type 'Result<Response, MoyaError>' to concrete decodable 'Result<DecodableModel, APIError>'
    /// by parsing BackendError formats from either success or faulure response if needed, and by decoding response data
    /// to provided Decodable type
    private static func mapResult<T: Decodable>(_ result: Result<Response, MoyaError>, dataField: DataField) -> Result<T, APIError> {
        switch result {
        case let .success(response):
            do {
                let model: T = try Self.mapResponse(response, dataField: dataField)
                return .success(model)
            } catch {
                return .failure(mapError(error))
            }
        case let .failure(error):
            return .failure(mapError(error))
        }
    }

    /// Map Error => APIError
    private static func mapError(_ error: Error) -> APIError {
        switch error {
        case let error as APIError:
            return error
        case let error as MoyaError:
            if let response = error.response {
                debugPrint("Curl (mapError): \(response.request?.curl() ?? "no request")")
                return decodeBackendError(data: response.data, statusCode: response.statusCode)
            }
            return .moya(error)
        default:
            return .unknown(error)
        }
    }

    /// Maps default Moya Response to concrete decodable Model
    /// by parsing BackendError formats from either success or faulure response if needed, and by decoding response data
    /// to provided Decodable type
    private static func mapResponse<T: Decodable>(_ response: Response, dataField: DataField) throws -> T {
        debugPrint("Curl: \(response.request?.curl() ?? "no request")")

        // Check statusCode in range 200 - 206 This mean success
        if 200 ... 206 ~= response.statusCode {
            do {
                // For EmptyModel
                if T.self == EmptyResponseModel.self {
                    return EmptyResponseModel() as! T
                }

                let object = try JSONSerialization.jsonObject(with: response.data, options: [])

                // Check dictionary type
                guard object is [String: Any] || object is [[String: Any]] else {
                    throw APIError.decoding(DecodingError(message: "Failed to decode object (reponse is not dictionary/array type)"))
                }

                // Check data field in dictionary type
                let pathData: Any?
                switch dataField {
                case .none:
                    pathData = object
                case .data, .results, .detail:
                    pathData = (object as? [String: Any])?[dataField.rawValue]
                }
                
                guard let dataJson = pathData else {
                    throw APIError.decoding(DecodingError(message: "Failed to decode object (no data field)"))
                }

                return try T(from: dataJson)
            } catch {
                throw APIError.decoding(DecodingError(message: "Failed to decode object"))
            }
        } else {
            throw decodeBackendError(data: response.data, statusCode: response.statusCode)
        }
    }

    /// Decode backend error
    private static func decodeBackendError(data: Data, statusCode: Int) -> APIError {
        do {
            var error = try BackendError(from: data)
            error.statusCode = statusCode
            return .backend(error)
        } catch {
            // The system error like this: "The data couldn't be read because it isn't in the correct format"
            // We don't want to use the un-readable message above
            return .decoding(DecodingError(message: "Failed to decode error object"))
        }
    }
}
