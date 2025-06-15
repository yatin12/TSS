import Foundation

struct paypalNonceSubmitResponse: Codable {
    let settings: Settings?
    let data: paypalNonceDataClass?
}
struct paypalNonceDataClass: Codable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
