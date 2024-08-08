//
//  SearchModel.swift
//  TSS
//
//  Created by apple on 18/07/24.
//

import Foundation

struct searchRequest: Encodable {
    let userId: String
    let searchText: String
}

// MARK: - Welcome
struct searchResponse: Codable {
    let settings: SettingsSearch?
    var data: [DataSearch]?
}

// MARK: - Datum
struct DataSearch: Codable {
    let id, title, content: String?
    let post_type: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case post_type
    }
}



// MARK: - Settings
struct SettingsSearch: Codable {
    let success: Bool?
    let message, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
}
