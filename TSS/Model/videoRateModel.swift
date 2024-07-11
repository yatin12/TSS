//
//  videoRateModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
struct videoRateRequest: Encodable {
    let userId: String
    let video_id: String
    let rating: String
    let comment: String
}
// MARK: - Welcome
struct videoRateResponse: Codable {
    let Settings: settingsVideoRate?
    let data: [DataVideoRate]?
}

// MARK: - Datum
struct DataVideoRate: Codable {
    let userID, videoID, rating, comment: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case videoID = "video_id"
        case rating, comment, message
    }
}

// MARK: - Settings
struct settingsVideoRate: Codable {
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
