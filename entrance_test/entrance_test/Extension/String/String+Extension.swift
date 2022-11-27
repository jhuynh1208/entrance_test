//
//  String+Extension.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isPassword() -> Bool {
        let regex = "^(?=.*[A-Z]|[a-z])(?=.*[!@#$&*])(?=.*[0-9]).{6,18}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
