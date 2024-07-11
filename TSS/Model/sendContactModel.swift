//
//  sendContactModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation
struct sendContactRequest: Encodable {
    let user_id: String
    let your_name: String
    let email: String
    let message: String
    let type: String

}
struct sendContactResponse: Codable {
    let status, message: String?
    let data: DataContact?
}

// MARK: - DataClass
struct DataContact: Codable {
    let userID, yourName, email, message: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case yourName = "your_name"
        case email, message, type
    }
}
