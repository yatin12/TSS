//
//  blogCategoryModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation

struct blogCategoryRequest: Encodable {
    let userId: String
    let categoryType: String
}
// MARK: - Welcome
struct blogCategoryResponse: Codable {
    let settings: SettingsBlog?
    let data: [DataBlog]?
}

// MARK: - Datum
struct DataBlog: Codable {
    let categoryID: Int?
    let categoryName: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName
    }
}

// MARK: - Settings
struct SettingsBlog: Codable {
    let success: Bool
    let message: String?
    let count: Int?
    let nextPage: Int?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
