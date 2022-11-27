//
//  UserProfile.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    let email: String
    let admin: Bool
    let firstName: String
    let lastName: String
    let createdAt: String
    let updatedAt: String
    let displayName: String
    let token: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case admin
        case firstName
        case lastName
        case createdAt
        case updatedAt
        case displayName
        case token
        case refreshToken
    }
}
