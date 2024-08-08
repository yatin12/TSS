//
//  blogByCategoryModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation

struct blogByCategoryRequest: Encodable {
    let category_id: String
    let userId: String
    let pagination_number: String
}

struct blogByCategoryResponse: Codable {
    let settings: SettingsBlogByCategory?
    var data: [DataBlogByCategory]?
}
// MARK: - Datum
struct DataBlogByCategory: Codable {
    let postID: String?
    let title, description, tag, date: String?
    let author: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, description, tag, date, author, thumbnail
    }
}
// MARK: - Settings
struct SettingsBlogByCategory: Codable {
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
