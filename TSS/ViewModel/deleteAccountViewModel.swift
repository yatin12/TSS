//
//  deleteAccountViewModel.swift
//  TSS
//
//  Created by apple on 07/08/24.
//

import Foundation
class deleteAccountViewModel
{
    func deleteAccountApi(userId: String, completion: @escaping (Result<deleteAccountResponse, Error>) -> Void)
    {
        let request = deleteAccountRequest(userId: userId)
        APIManager.shared.deleteAccountApi(request: request, responseModelType: deleteAccountResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
        
    }
}
