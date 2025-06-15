import Foundation

// MARK: - Welcome
struct RelationshipDataSubmitResponse: Codable {
    let settings: Settings?
    let data: RealtionDataClass?
}
struct RealtionDataClass: Codable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
