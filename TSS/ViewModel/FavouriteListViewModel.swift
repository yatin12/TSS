//
//  FavouriteListViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
class FavouriteListViewModel
{
    func favouriteList(userId: String, completion: @escaping (Result<favouriteResponse, Error>) -> Void)
    {
        let request = favBlogRequest(userId: userId)
        APIManager.shared.favBlogList(request: request, responseModelType: favouriteResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
