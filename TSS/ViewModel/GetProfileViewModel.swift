//
//  GetProfileViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
class GetProfileViewModel
{
    func getProfile(userId: String, completion: @escaping (Result<GetProfileResponse, Error>) -> Void)
    {
        let request = getProfileRequest(userId: userId)
        APIManager.shared.getProfileDetails(request: request, responseModelType: GetProfileResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
