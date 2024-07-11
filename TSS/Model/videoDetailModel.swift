//
//  videoListModel.swift
//  TSS
//
//  Created by apple on 08/07/24.
//

import Foundation
struct videoDetailRequest: Encodable {
    let userId: String
    let videoId: String
}

// MARK: - Welcome
struct videoDetailResponse: Codable {
    let settings: SettingsVideoDetail?
    let data: DataVideoDetail?
}
// MARK: - DataClass
struct DataVideoDetail: Codable {
    let eVideo: [EVideoDetail]?

    enum CodingKeys: String, CodingKey {
        case eVideo = "e-video"
    }
}
// MARK: - EVideo
struct EVideoDetail: Codable {
    let thumbnail: String?
    let duration: String?
    let videoURL: String?
    let title, subtitle, date, totalViews: String?
    let description, totalLikes: String?
    let isLike, isWatch: Bool?
    let socialURL: String?
    let upNext: [upNext]?
    let moreVideos: MoreVideos?
    let reviewDetails: ReviewDetails?

    enum CodingKeys: String, CodingKey {
        case thumbnail, duration
        case videoURL = "videoUrl"
        case title, subtitle, date, totalViews, description, totalLikes, isLike, isWatch
        case socialURL = "socialUrl"
        case upNext, moreVideos, reviewDetails
    }
}
// MARK: - UpNext
struct upNext: Codable {
    let thumbnail, title: String?
    let date: String?
    let totalViews: String?
}
// MARK: - MoreVideos
struct MoreVideos: Codable {
    let thumbnail, title: String?
    let duration: String?
    let date: String?
}

// MARK: - ReviewDetails
struct ReviewDetails: Codable {
    let rating, comment: String?
}
// MARK: - Settings
struct SettingsVideoDetail: Codable {
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
