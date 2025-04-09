//
//  AddFCMTokenViewModel.swift
//  Uveaa Solar
//
//  Created by apple on 05/03/24.
//

import Foundation

class AddFCMTokenViewModel
{
    func addFCMToken(deviceId: String, fcmToken: String, userId: String, completion: @escaping (Result<AddFCMTokenResponse, Error>) -> Void)
    {
        let request = AddFCMTokenRequest(deviceId: deviceId, fcmToken: fcmToken, userId: userId)
        
        APIManager.shared.AddFCMToken(request: request, responseModelType: AddFCMTokenResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
