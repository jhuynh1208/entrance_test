import Foundation
import Alamofire
import Moya

/// A class, which represents the interceptor for Moya requests
/// Implementation of ```RequestRetrier``` protocol doesn't work for some reasons.
/// See https://github.com/Moya/Moya/issues/2096#issuecomment-782565397 for more details.
class APIRequestRetrier: Retrier {
    init(token: Tokenable) {
//        let authManager = AuthAPIManager(session: session)

        super.init { request, _, _, completion in
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401,
                  request.retryCount < 3, token.token != nil
            else {
                completion(.doNotRetry)
                return
            }

            print("Auto-refresh token")
            // FIXME: - Use auto-refresh API if support in the future, for now just return an error to ignore auto refresh
            let error = APICustomError(message: "Do not support auto-refresh token now")
            completion(.doNotRetryWithError(error))
            // Refresh token
//            authManager.refreshToken { result in
//                switch result {
//                case .success:
//                    completion(.retry)
//                case let .failure(error):
//                    completion(.doNotRetryWithError(error))
//                }
//            }
        }
    }
}

public protocol Tokenable {
    var token: String? { get set }
}
