//
//  membershipViewModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation

class membershipViewModel
{
    func getMembershipPlan(userId: String, planType: String, completion: @escaping (Result<membershipPlanResponse, Error>) -> Void)
    {
        let request = membershipRequest(userId: userId, planType: planType)
        
        APIManager.shared.membershipPlanList(request: request, responseModelType: membershipPlanResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
