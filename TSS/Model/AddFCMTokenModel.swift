//
//  AddFCMTokenModel.swift
//  Uveaa Solar
//
//  Created by apple on 05/03/24.
//

import Foundation

struct AddFCMTokenRequest: Encodable {
    let deviceId: String
    let fcmToken: String
    let userId: String
}


// MARK: - Welcome
struct AddFCMTokenResponse: Codable {
    let settings: SettingsAddFCM?
    
}

// MARK: - Settings
struct SettingsAddFCM: Codable {
    let success: Bool?
    let message: String?
    let count, nextPage: Int?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
