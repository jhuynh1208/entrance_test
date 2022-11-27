//
//  SignupRequestParam.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import Foundation

struct SignupRequestParam: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case password
    }
}
