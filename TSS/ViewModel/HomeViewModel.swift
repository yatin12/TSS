//
//  HomeViewModel.swift
//  TSS
//
//  Created by apple on 05/08/24.
//

import Foundation

class HomeViewModel
{
    func getHomeListData(userId: String, completion: @escaping (Result<HomeResposne, Error>) -> Void)
    {
        let request = HomeRequest(userId: userId)
        APIManager.shared.getHomeList(request: request, responseModelType: HomeResposne.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
