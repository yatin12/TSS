import Foundation

// MARK: - Welcome
struct PackageModelResponse: Codable {
    let settings: SettingsPKG
    let data: [PackageData]
}

// MARK: - Datum
struct PackageData: Codable, Identifiable, Equatable {
    let id = UUID() // For SwiftUI ForEach
    let postID, title, description, packagePrice: String
    let duration: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, description
        case packagePrice = "package_price"
        case duration
    }
}
// MARK: - Settings
struct SettingsPKG: Codable {
    let success: Bool
    let message, count, nextPage: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}
