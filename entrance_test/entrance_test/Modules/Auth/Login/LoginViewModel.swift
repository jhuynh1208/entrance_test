//
//  LoginViewModel.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit
import Combine

class LoginViewModel: BaseViewModel {
    @Published var isRemember: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    
    private lazy var apiManager = AuthAPIManager(token: dependency.tokenable)
}

// MARK: - Helper Methods
extension LoginViewModel {
    func validate() -> [CustomError] {
        var errors: [CustomError] = []
        
        if email.isEmpty {
            errors.append(CustomError(type: .email, message: "Email is required."))
        } else if !email.isEmail() {
            errors.append(CustomError(type: .email, message: "Email is invalid."))
        }
        
        if password.isEmpty {
            errors.append(CustomError(type: .password, message: "Password is required."))
        } else if password.count < 6 || password.count > 18 {
            errors.append(CustomError(type: .password, message: "Password must be between 6-18 characters."))
        } else if !password.isPassword() {
            errors.append(CustomError(type: .password, message: "Password must contain at least one digit, one special character, and one letter."))
        }
        
        return errors
    }
}

// MARK: - APIs
extension LoginViewModel {
    func login(completion: @escaping (APIError?) -> Void) {
        apiManager.login(params: LoginRequestParam(email: email,
                                                   password: password))
        .sink { incomplete in
            switch incomplete {
            case .finished: break
            case .failure(let error):
                completion(error)
            }
        } receiveValue: { [weak self] profile in
            let session = Session(token: profile.token)
            self?.dependency.tokenable = session
            completion(nil)
        }
        .store(in: &subscriptions)
    }
}
