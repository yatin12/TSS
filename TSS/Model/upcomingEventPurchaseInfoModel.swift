

import Foundation
/*
struct upcomingEventPurchaseRequest: Encodable {
    let userID: String
    let postid: String
    let productId: String
    let transactionIdentifier: String
    let transactionDate: String
    let transactionState: String
    let productPrice: String
    let productPriceLocal: String
    let productPurchaseCurrencyCode: String
    let planType: String
    let isCancelled: String

}
*/
// MARK: - Welcome
struct upcomingEventPurchaseResponse: Codable {
    let settings: upcomingEventSettings
    let data: upcomingEventData
}

// MARK: - DataClass
struct upcomingEventData: Codable {
}

// MARK: - Settings
struct upcomingEventSettings: Codable {
    let success: Bool?
    let message, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userID = "userId"
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            success = try container.decodeIfPresent(Bool.self, forKey: .success)
            message = try container.decodeIfPresent(String.self, forKey: .message)
            
            // Handle userID as either String or Int
            if let userIDString = try? container.decodeIfPresent(String.self, forKey: .userID) {
                userID = userIDString
            } else if let userIDInt = try? container.decodeIfPresent(Int.self, forKey: .userID) {
                userID = String(userIDInt)
            } else {
                userID = nil
            }
        }
}
