//
//  SearchViewModel.swift
//  TSS
//
//  Created by apple on 19/07/24.
//

import Foundation

class SearchViewModel
{
    func getSearchList(userId: String, searchText: String, completion: @escaping (Result<searchResponse, Error>) -> Void)
    {
        let request = searchRequest(userId: userId, searchText: searchText)
        APIManager.shared.searchList(request: request, responseModelType: searchResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
