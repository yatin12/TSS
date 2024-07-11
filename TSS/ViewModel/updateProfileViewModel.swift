//
//  updateProfileViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation

class updateProfileViewModel
{
    func updateProfile(profileImgData: Data?, userId: String, userName: String, email: String, phone: String, password: String, completion: @escaping (Result<GetProfileResponse, Error>) -> Void)
    {
        APIManager.shared.updateProfile(profileImgData: profileImgData, userId: userId, userName: userName, email: email, phone: phone, password: password, responseModelType: GetProfileResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
