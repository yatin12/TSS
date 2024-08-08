//
//  LikeVideoModel.swift
//  TSS
//
//  Created by apple on 17/07/24.
//

import Foundation
struct LikeVideoRequest: Encodable {
    let user_id: String
    let video_id: String
    let action: String
    let `Type`: String
}
// MARK: - Welcome
struct likeVideoResponse: Codable {
    let settings: SettingsLikeVideo?
    let data: DataLikeVideo?
}

// MARK: - DataClass
struct DataLikeVideo: Codable {
    let type, videoID: String?

    enum CodingKeys: String, CodingKey {
        case type
        case videoID = "video_id"
    }
}

// MARK: - Settings
struct SettingsLikeVideo: Codable {
    let success: Bool?
    let message, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
}
