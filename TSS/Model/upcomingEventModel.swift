//
//  upcomingEventModel.swift
//  TSS
//
//  Created by khushbu bhavsar on 06/09/24.
//

import Foundation
struct upcomingRequest: Encodable {
    let userId: String
    let pagination_number: String
}
struct upcomingEventResponse: Codable {
    let settings: SettingsUpcoming?
    var data: [DataUpcoming]?
}
// MARK: - Datum
struct DataUpcoming: Codable {
    let ispurchased: String?
    let productId: String?
    let id, title: String?
    let thumbnail: String?
    let description, eventStartDate, eventStartTime, eventEndDate: String?
    let eventEndTime, author, regularPrice, salePrice: String?
    let eventPrice, eventDiscountText: String?

    enum CodingKeys: String, CodingKey {
        case ispurchased
        case productId
        case id, title, thumbnail, description
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case author
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case eventPrice = "event_price"
        case eventDiscountText = "event_discount_text"
    }
}

// MARK: - Settings
struct SettingsUpcoming: Codable {
    let success: Bool?
    let message, count, nextPage, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}

