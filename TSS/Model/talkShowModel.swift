//
//  talkShowModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
struct talkShowListRequest: Encodable {
    let userId: String
    let category_id: String
}
struct talkShowListResponse: Codable {
    let settings: SettingsTalkShow?
    let data: [DataTalkShow]?
}

// MARK: - Datum
struct DataTalkShow: Codable {
    let thumbnail: String?
    let duration, title, authorName, date: String?
}

// MARK: - Settings
struct SettingsTalkShow: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
