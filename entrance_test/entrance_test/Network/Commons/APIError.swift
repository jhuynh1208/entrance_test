import Foundation
import Moya

/// Error code
enum APIErrorCode: Int {
    case unauthorized = 401
    case invalidCode = 400
}

/// Decoding error
struct DecodingError: LocalizedError {
    let message: String

    var errorDescription: String? {
        return message
    }
}

/// Backend error
struct BackendError: Decodable, LocalizedError {
    var errors: Errors
    var statusCode: Int
    var success: Bool

    var errorDescription: String? {
        return errors.message.first
    }
}

struct Errors: Decodable {
    var message: [String]
    var error: String
    var stack: String
}

/// Possible error types that can be returned by APIManager
enum APIError: LocalizedError {
    case moya(MoyaError)
    case unknown(Error)
    case encoding(Error)
    case decoding(Error)
    case backend(BackendError)
    case invalid

    var errorDescription: String? {
        switch self {
        case let .moya(error): return error.localizedDescription
        case let .encoding(error): return error.localizedDescription
        case let .decoding(error): return error.localizedDescription
        case let .backend(error): return error.localizedDescription
        case let .unknown(error): return error.localizedDescription
        case .invalid: return "Something goes wrong, please, try again"
        }
    }

    var backendCode: Int? {
        switch self {
        case let .backend(error):
            return error.statusCode
        default:
            return nil
        }
    }
    
    var backendError: BackendError? {
        switch self {
        case .backend(let backendError):
            return backendError
        default:
            return nil
        }
    }
}

/// Represents api error.
struct APICustomError: LocalizedError {
    let message: String
    let statusCode: Int

    public var errorDescription: String? {
        return [message.isEmpty ? nil : message, "Unknown Error."].compactMap { $0 }.first
    }
}

extension APICustomError {
    init(message: String) {
        self.message = message
        self.statusCode = 0    // For common message
    }
}
