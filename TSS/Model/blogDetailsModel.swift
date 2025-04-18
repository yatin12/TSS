//
//  blogDetailsModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
struct blogDetailsRequest: Encodable {
    let postId: String
    let userId: String
}

struct blogDetailsResponse: Codable {
    let settings: SettingsBlogDetail?
    let data: DataBlogDetail?
}
// MARK: - DataClass
struct DataBlogDetail: Codable {
    let title, description: String?
    let tag: [String]?
    let date, author: String?
    let thumbnail: String?
    let facebookURL, instaURL, tiktokURL, previusPostID: String?
    let twitter_url: String?
    let linkedin_url: String?
    let nextPostID: String?
    let relatedBlogs: [RelatedBlog]?

    enum CodingKeys: String, CodingKey {
        case title, description, tag, date, author, thumbnail
        case twitter_url
        case linkedin_url
        case facebookURL = "facebookUrl"
        case instaURL = "instaUrl"
        case tiktokURL = "tiktokUrl"
        case previusPostID = "previusPostId"
        case nextPostID = "NextPostId"
        case relatedBlogs
    }
}
// MARK: - RelatedBlog
struct RelatedBlog: Codable {
    let id: String
    let title, description, date: String?
    let tag: [String]?
    let author: String?
    let thumbnail: String?
}
// MARK: - Settings
struct SettingsBlogDetail: Codable {
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
