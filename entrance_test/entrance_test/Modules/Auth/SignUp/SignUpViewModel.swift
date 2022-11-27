//
//  SignUpViewModel.swift
//  entrance_test
//
//  Created by Thiện on 26/11/2022.
//

import Combine

enum AuthErrorType {
    case firstName
    case lastName
    case email
    case password
}

class SignUpViewModel: BaseViewModel {
    @Published var isAgreePolicyTerm: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
}

// MARK: - Helper Methods
extension SignUpViewModel {
    func validate() -> [CustomError] {
        var errors: [CustomError] = []
        
        if firstName.isEmpty {
            errors.append(CustomError(type: .firstName, message: "First name is required."))
        } else if firstName.count < 2 {
            errors.append(CustomError(type: .firstName, message: "First name must be at least 2 characters."))
        }
        
        if lastName.isEmpty {
            errors.append(CustomError(type: .lastName, message: "Last name is required."))
        } else if lastName.count < 2 {
            errors.append(CustomError(type: .lastName, message: "Last name must be at least 2 characters."))
        }
        
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
extension SignUpViewModel {
    func signup() {
        
    }
}

struct CustomError {
    let type: AuthErrorType
    let message: String
}
