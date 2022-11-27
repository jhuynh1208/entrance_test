import Foundation
import Alamofire
import Moya

/// Custom ParameterEncoding for such case, when body is array of Jsons
/// ex. [{"user" : 12}, {"user" : 2}, {"user" : 8}]
/// Also see  JsonArrayParameterKey.swift
struct JsonArrayEncoding: Moya.ParameterEncoding {
    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters?["jsonArray"] else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}
