//
//  HomeModel.swift
//  TSS
//
//  Created by apple on 05/08/24.
//

import Foundation
struct HomeRequest: Encodable {
    let userId: String
}

// MARK: - Welcome
struct HomeResposne: Codable {
    let settings: SettingsHome?
    let data: DataHome?
}

// MARK: - DataClass
struct DataHome: Codable {
    let videoDetails: [VideoDetail]?
    let recentNews: [EmpowermentVideo]?
    let recommendedEpisodes: [RecommendedEpisode]?
    let meetTheSisters: [MeetTheSister]?
    let season1BTS: [Season1BT]?
    let season, empowermentVideo: [EmpowermentVideo]?
}

// MARK: - EmpowermentVideo
struct EmpowermentVideo: Codable {
    let id, title, description, tags: String?
    let date, author: String?
    let thumbnail: String?
    let category: String?
}
// MARK: - Season1BT
struct Season1BT: Codable {
    let url: String
}
// MARK: - MeetTheSister
struct MeetTheSister: Codable {
    let id, name, description: String?
    let thumbnail: String?
}

// MARK: - RecommendedEpisode
struct RecommendedEpisode: Codable {
    let id, title, description: String?
    let thumbnail: String?
    let tags: String?
}

// MARK: - VideoDetail
struct VideoDetail: Codable {
    let id, title: String?
    let videourl: String?
    let thumbnail: String?
}

// MARK: - Settings
struct SettingsHome: Codable {
    let success: Bool?
    let code, message: String?
    let count: Int?
    let nextPage: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, code, message, count, nextPage
        case userID = "userId"
    }
}
