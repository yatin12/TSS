import Foundation

struct eventPaypalNonceSubmitResponse: Codable {
    let settings: Settings?
    let data: eventPaypalNonceDataClass?
}
struct eventPaypalNonceDataClass: Codable {
    let userID: String
    let orderId: Int
    let transactionId: String
    let status: String
    let amount: String
    let eventName: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case orderId = "order_id"
        case transactionId = "transaction_id"
        case status
        case amount
        case eventName = "event_name"
    }
}
