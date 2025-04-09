

import Foundation
struct subscriptionPurchaseRequest: Encodable {
    let userID: String
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
struct subscriptionCancelPurchaseRequest: Encodable {
    let userID: String
    let isCancelled: String
}
// MARK: - Welcome
struct subscriptionPurchaseResponse: Codable {
    let settings: SettingsSubscription
    let data: DataClassSubscription
}

// MARK: - DataClass
struct DataClassSubscription: Codable {
    let planName, planNameFull: String?

    enum CodingKeys: String, CodingKey {
        case planName
        case planNameFull = "planName_full"
    }
}

// MARK: - Settings
struct SettingsSubscription: Codable {
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

/*
struct subscriptionPurchaseResponse: Codable {
    let settings: SettingsSubscription?
    let data: DataClassSubscription?
}
// MARK: - DataClass
struct DataClassSubscription: Codable {
    let  planName, planName_full: String?
   

    enum CodingKeys: String, CodingKey {
         case planName_full
        case planName
    }
}

// MARK: - Settings
struct SettingsSubscription: Codable {
    let success: Bool?
    let message: String?
    let userId: Int?
   // let code: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case userId
       // case code
    }
}
*/
