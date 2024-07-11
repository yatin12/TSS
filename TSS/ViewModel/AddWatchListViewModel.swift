//
//  AddWatchListViewModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation

class AddWatchListViewModel
{
    func addWatchList(user_id: String, video_id: String, completion: @escaping (Result<AddWatchListResponse, Error>) -> Void)
    {
        let request = addWatchListRequest(user_id: user_id, video_id: video_id)
        APIManager.shared.addWatchList(request: request, responseModelType: AddWatchListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
