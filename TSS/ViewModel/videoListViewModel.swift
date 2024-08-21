//
//  videoListViewModel.swift
//  TSS
//
//  Created by apple on 08/07/24.
//

import Foundation

class videoListViewModel
{
    func videoList(userId: String, category_id: String, pagination_number: String, completion: @escaping (Result<videoListResponse, Error>) -> Void)
    {
        let request = videoListRequest(userId: userId, category_id: category_id, pagination_number: pagination_number)
        
        APIManager.shared.videoList(request: request, responseModelType: videoListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}

