//
//  LoginRequestParam.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

struct LoginRequestParam: Encodable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
