//
//  watchListModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
struct watchListRequest: Encodable {
    let userId: String
}
// MARK: - Welcome
struct watchListResponse: Codable {
    let settings: SettingsWatchList?
    let data: [DataWatchList]?
}

// MARK: - Datum
struct DataWatchList: Codable {
    let id, title, description, tag: String
    let date: String?
    let author: [Int]?
    let thumbnail: String?
}

// MARK: - Settings
struct SettingsWatchList: Codable {
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
