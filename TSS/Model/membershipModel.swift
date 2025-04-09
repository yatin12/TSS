//
//  membershipModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation
struct membershipRequest: Encodable {
    let userId: String
    let planType: String
}
// MARK: - Welcome
struct membershipPlanResponse: Codable {
    let settings: SettingsMememberShip?
    var data: [DataMemberShip]?
}

// MARK: - Datum
struct DataMemberShip: Codable {
    let productId: String?
    let id, name, description, initialPayment: String?
    let billingAmount, cycleNumber, cyclePeriod, billingLimit: String?
    let trialAmount, trialLimit, expirationNumber, expirationPeriod: String?
    let isActive: Bool?

    enum CodingKeys: String, CodingKey {
        case productId
        case id, name, description
        case initialPayment = "initial_payment"
        case billingAmount = "billing_amount"
        case cycleNumber = "cycle_number"
        case cyclePeriod = "cycle_period"
        case billingLimit = "billing_limit"
        case trialAmount = "trial_amount"
        case trialLimit = "trial_limit"
        case expirationNumber = "expiration_number"
        case expirationPeriod = "expiration_period"
        case isActive
    }
}

// MARK: - Settings
struct SettingsMememberShip: Codable {
    let success: Bool?
    let message: String?
    let count: Int?
    let nextPage, userID: String?

    enum CodingKeys: String, CodingKey {
        case success, message, count, nextPage
        case userID = "userId"
    }
}

