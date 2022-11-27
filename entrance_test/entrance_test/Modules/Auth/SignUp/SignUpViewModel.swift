//
//  SignUpViewModel.swift
//  entrance_test
//
//  Created by Thiện on 26/11/2022.
//

import Combine

class SignUpViewModel: BaseViewModel {
    @Published var isAgreePolicyTerm: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
}

// MARK: - Helper Methods
extension SignUpViewModel {
    private func validate() {
        
    }
}
