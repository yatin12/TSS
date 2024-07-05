//
//  RegistrationModel.swift
//  TSS
//
//  Created by apple on 03/07/24.
//

import Foundation
import UIKit

struct RegistrationRequest: Encodable {
    let first_name: String
    let last_name: String
    let username: String
    let email: String
    let password: String
    let dob: String
    let gender: String
    let country: String
    let device_token: String
}

struct registrationResponse: Codable {
    let settings: RegSettings?
    let data: RegData?
}
struct RegData: Codable {
    let userID: Int?
    let firstName, lastName, username, email: String?
    let birthday, gender, country: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email, birthday, gender, country
    }
}
// MARK: - Settings
struct RegSettings: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage: String?
    let userID: Int?
    let diviceToken, authorization: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
        case diviceToken
        case authorization = "Authorization"
    }
}
