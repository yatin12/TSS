//
//  watchListViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
class watchListViewModel
{
    func watchList(userId: String, completion: @escaping (Result<watchListResponse, Error>) -> Void)
    {
        let request = watchListRequest(userId: userId)
        APIManager.shared.WatchBlogList(request: request, responseModelType: watchListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }

    }
}
