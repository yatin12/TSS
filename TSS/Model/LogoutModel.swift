//
//  LogoutModel.swift
//  TSS
//
//  Created by apple on 20/08/24.
//

import Foundation
struct logoutRequest: Encodable {
    let userId: String
}
// MARK: - Welcome
struct logoutResponse: Codable {
    let settings: SettingsLogout?
  
}

// MARK: - Settings
struct SettingsLogout: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
