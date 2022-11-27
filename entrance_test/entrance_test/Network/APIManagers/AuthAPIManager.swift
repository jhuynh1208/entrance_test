//
//  AuthAPIManager.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import Foundation
import Combine

class AuthAPIManager: BaseAPIManager<AuthTarget> {
    
    func signup(params: SignupRequestParam) -> AnyPublisher<UserProfile, APIError> {
        return request(target: .signup(params.asDictionary()), dataField: .none)
    }
    
    func login(params: LoginRequestParam) -> AnyPublisher<UserProfile, APIError> {
        return request(target: .login(params.asDictionary()), dataField: .none)
    }
}
