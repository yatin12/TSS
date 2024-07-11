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
struct watchListResponse: Codable {
    let settings: SettingsWatchList?
    let data: DataWatchList?
}

// MARK: - DataClass
struct DataWatchList: Codable {
    let postWatchlist: [PostWatchlist]?

    enum CodingKeys: String, CodingKey {
        case postWatchlist = "post_watchlist"
    }
}

// MARK: - PostWatchlist
struct PostWatchlist: Codable {
    let title, description, tag, date: String?
    let author: [String]?
    let thumbnail: String?
}

// MARK: - Settings
struct SettingsWatchList: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage: Int?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
