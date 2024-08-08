//
//  AddWatchListModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation

struct addWatchListRequest: Encodable {
    let user_id: String
    let video_id: String
}

struct AddWatchListResponse: Codable {
    let settings: SettingsAddwatchList?
   // let data: DataAddwatchList?
}

// MARK: - DataClass
struct DataAddwatchList: Codable {
    let postWatchlist: [Int]?

    enum CodingKeys: String, CodingKey {
        case postWatchlist = "post_watchlist"
    }
}

// MARK: - Settings
struct SettingsAddwatchList: Codable {
    let success: Bool?
    let message: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
}
