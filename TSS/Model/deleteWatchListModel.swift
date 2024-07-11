//
//  deleteWatchListModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation

struct deleteWatchListRequest: Encodable {
    let user_id: String
    let video_id: String
}

struct deleteWatchListResponse: Codable {
    let settings: SettingsDeleteWatchList?
    let data: DataDeleteWatchList?
}

// MARK: - DataClass
struct DataDeleteWatchList: Codable {
    let postWatchlist: [Int]?

    enum CodingKeys: String, CodingKey {
        case postWatchlist = "post_watchlist"
    }
}

// MARK: - Settings
struct SettingsDeleteWatchList: Codable {
    let success: Bool?
    let message: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
}
