import Foundation
import Moya

final class DisableCookiePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutableRequest = request
        mutableRequest.httpShouldHandleCookies = false
        return mutableRequest
    }
}
