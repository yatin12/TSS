//
//  ForgotPasswordModel.swift
//  TSS
//
//  Created by apple on 07/08/24.
//

import Foundation
struct ForgotPasswordRequest: Encodable {
    let email: String
}

// MARK: - Welcome
struct ForgotPasswordResponse: Codable {
    let settings: SettingsForgotPass?
    let data: DataFrogotPass?
}

// MARK: - DataClass
struct DataFrogotPass: Codable {
    let email: String?
}

// MARK: - Settings
struct SettingsForgotPass: Codable {
    let success: Bool?
    let code, message: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case success, code, message
        case userID = "userId"
    }
}
