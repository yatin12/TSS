//
//  sendContactModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation
struct sendContactRequest: Encodable {
    let user_id: String
    let your_name: String
    let email: String
    let message: String
    let type: String

}
// MARK: - Welcome
struct sendContactResponse: Codable {
    let settings: SettingsContact?
    let data: DataContact?
}

// MARK: - DataClass
struct DataContact: Codable {
    let userID, yourName, email, message: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case yourName = "your_name"
        case email, message, type
    }
}

// MARK: - Settings
struct SettingsContact: Codable {
    let success: Bool
    let message, userID: String

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
}

/*
struct sendContactResponse: Codable {
    let status, message: String?
    let data: DataContact?
}

// MARK: - DataClass
struct DataContact: Codable {
    let userID, yourName, email, message: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case yourName = "your_name"
        case email, message, type
    }
}
*/
