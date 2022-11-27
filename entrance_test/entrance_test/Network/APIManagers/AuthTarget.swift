//
//  AuthTarget.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import Moya

enum AuthTarget {
    case login
    case signup(SignupRequestParam)
    case logout
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        return URL(string: BaseAPIManager<Self>.basePath)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/auth/signin"
        case .logout:
            return "/api/auth/logout"
        case .signup:
            return "/api/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .logout, .signup:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(let params):
            return .requestParameters(parameters: params.toJson(),
                                      encoding: JSONEncoding.default)
        case .logout, .login:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - AccessTokenAuthorizable

extension AuthTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .signup:
            return .none
        case .logout:
            return .basic
        }
    }
}
