//
//  loginModel.swift
//  TSS
//
//  Created by apple on 02/07/24.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let device_token: String
}

struct loginResponse: Codable {
    let settings: Settings?
    let data: DataClass?
}
// MARK: - DataClass
struct DataClass: Codable {
    let id: String?
    let userLogin, userNicename, userEmail, userURL: String?
    let userRegistered, displayName: String?
    let membershipLevel: MembershipLevel?
   // let membershipLevel: Bool?

    let roles: [String]?
    let allcaps: Allcaps?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case userLogin = "user_login"
        case userNicename = "user_nicename"
        case userEmail = "user_email"
        case userURL = "user_url"
        case userRegistered = "user_registered"
        case displayName = "display_name"
        case membershipLevel = "membership_level"
        case roles, allcaps
    }
}
// MARK: - Allcaps
struct Allcaps: Codable {
    let read, level0, subscriber: Bool?

    enum CodingKeys: String, CodingKey {
        case read
        case level0 = "level_0"
        case subscriber
    }
}
// MARK: - MembershipLevel
struct MembershipLevel: Codable {
    let id, membershipLevelID, subscriptionID, name: String?
    let description, confirmation, expirationNumber, expirationPeriod: String?
    let allowSignups: String?
    let billingAmount: String?
    let initialPayment: String?
    let cycleNumber, cyclePeriod, billingLimit: String?
    let trialAmount: Int?
    let trialLimit, codeID, startdate: String?
    let enddate: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case membershipLevelID = "id"
        case subscriptionID = "subscription_id"
        case name, description, confirmation
        case expirationNumber = "expiration_number"
        case expirationPeriod = "expiration_period"
        case allowSignups = "allow_signups"
        case initialPayment = "initial_payment"
        case billingAmount = "billing_amount"
        case cycleNumber = "cycle_number"
        case cyclePeriod = "cycle_period"
        case billingLimit = "billing_limit"
        case trialAmount = "trial_amount"
        case trialLimit = "trial_limit"
        case codeID = "code_id"
        case startdate, enddate
    }
}
// MARK: - Settings
struct Settings: Codable {
    let success: Bool?
    let message, count, nextPage: String?
    let userID: String?
    let diviceToken, authorization: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
        case diviceToken
        case authorization = "Authorization"
    }
}
