
import Foundation

struct eventPaypalNonceSubmitResponse: Codable {
    let settings: Settings?
    let data: eventPaypalNonceDataClass?
}
struct eventPaypalNonceDataClass: Codable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
