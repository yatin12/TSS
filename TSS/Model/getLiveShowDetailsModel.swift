//
//  getLiveShowDetailsModel.swift
//  TSS
//
//  Created by khushbu bhavsar on 28/08/24.
//

import Foundation
struct lievShowDetailRequest: Encodable {
    let userId: String
    let postId: String
}
struct liveShowDetailResponse: Codable {
    let settings: SettingsLiveShow?
    let data: DataClassLiveShow?
}

// MARK: - DataClass
struct DataClassLiveShow: Codable {
    let id, title: String?
    let thumbnail: String?
    let description: String?
    let liveShowURL1, liveShowURL2: String?
    let startDate, startTime, endDate, endTime: String?

    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, description
        case liveShowURL1 = "live_show_url_1"
        case liveShowURL2 = "live_show_url_2"
        case startDate = "start_date"
        case startTime = "start_time"
        case endDate = "end_date"
        case endTime = "end_time"
    }
}

// MARK: - Settings
struct SettingsLiveShow: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
