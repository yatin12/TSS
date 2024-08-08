//
//  deleteAccountModel.swift
//  TSS
//
//  Created by apple on 07/08/24.
//

import Foundation
struct deleteAccountRequest: Encodable {
    let userId: String
}

// MARK: - Welcome
struct deleteAccountResponse: Codable {
    let settings: SettingsDelAcc?
    let data: DataDelAcc?
}

// MARK: - DataClass
struct DataDelAcc: Codable {
    let userID, message: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case message
    }
}

// MARK: - Settings
struct SettingsDelAcc: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage: Int?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
