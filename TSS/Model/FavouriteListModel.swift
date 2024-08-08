//
//  FavouriteListModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
struct favBlogRequest: Encodable {
    let userId: String
}

struct favouriteResponse: Codable {
    let settings: SettingsFav?
    let data: DataFavourite?
}

// MARK: - DataClass
struct DataFavourite: Codable {
    let videosLiked, talkshowLiked: [Favliked]?

    enum CodingKeys: String, CodingKey {
        case videosLiked = "videos_liked"
        case talkshowLiked = "talkshow_liked"
    }
}

// MARK: - Liked
struct Favliked: Codable {
    let id: String?
    let title, description, tag, date: String?
    let author: [String]?
    let thumbnail: String?
}

// MARK: - Settings
struct SettingsFav: Codable {
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
