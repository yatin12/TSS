//
//  LogoutViewModel.swift
//  TSS
//
//  Created by apple on 20/08/24.
//

import Foundation
class LogoutViewModel
{
    func logoutAPi(userId: String, completion: @escaping (Result<logoutResponse, Error>) -> Void)
    {
        let request = logoutRequest(userId: userId)
        
        APIManager.shared.logoutApi(request: request, responseModelType: logoutResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
        
    }
}
