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
    let postType: String
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
    let id: String?
    let thumbnail: String?
    let duration, videoURL: String?
    let Trailer_Video_URL: String?
    let Full_Video_URL: String?
    let videoFileUrl: String?
    let title, subtitle, date, totalViews: String?
    let description, totalLikes: String?
    let isLike, isWatch: Bool?
    let socialURL: String?
    let upNext, moreVideos: [MoreVideo]?
    let reviewDetails: [ReviewDetail]?

    enum CodingKeys: String, CodingKey {
        case id, thumbnail, duration
        case videoURL = "videoUrl"
        case videoFileUrl = "videoFileUrl"
        case Trailer_Video_URL,Full_Video_URL
        case title, subtitle, date, totalViews, description, totalLikes, isLike, isWatch
        case socialURL = "socialUrl"
        case upNext, moreVideos, reviewDetails
    }
}

// MARK: - MoreVideo
struct MoreVideo: Codable {
    let id: String?
    let thumbnail: String?
    let title, totalViews, date: String?
}

// MARK: - ReviewDetail
struct ReviewDetail: Codable {
    let id, username, commentDate, rating: String?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case id, username
        case commentDate = "comment_date"
        case rating, comment
    }
}

// MARK: - Settings
struct SettingsVideoDetail: Codable {
    let success: Bool?
    let message: String?
    let count: String?
    let nextPage: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}

