//
//  videoListModel.swift
//  TSS
//
//  Created by apple on 08/07/24.
//

import Foundation
struct videoListRequest: Encodable {
    let userId: String
    let category_id: String
}
// MARK: - Welcome
struct videoListResponse: Codable {
    let settings: SettingsVideoList?
    let data: [DataVideoList]?
}

// MARK: - Datum
struct DataVideoList: Codable {
    let id: String?
    let thumbnail: String?
    let duration: String?
    let title, authorName, date: String?
}

// MARK: - Settings
struct SettingsVideoList: Codable {
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


