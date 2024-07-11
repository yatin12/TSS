//
//  GetProfileModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
// MARK: - Welcome
struct getProfileRequest: Encodable {
    let userId: String
}

struct GetProfileResponse: Codable {
    let settings: SettingsGetProfile?
    let data: DataGetProfile?
}

// MARK: - DataClass
struct DataGetProfile: Codable {
    let imageURL: String?
    let userName, email, phone, password: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case userName, email, phone, password
    }
}

// MARK: - Settings
struct SettingsGetProfile: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
