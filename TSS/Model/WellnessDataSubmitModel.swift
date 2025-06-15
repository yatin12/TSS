import Foundation

struct WellnessDataSubmitResponse: Codable {
    let settings: Settings?
    let data: WellnessDataClass?
}
struct WellnessDataClass: Codable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
