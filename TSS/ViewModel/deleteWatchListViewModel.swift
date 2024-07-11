//
//  deleteWatchListViewModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation

class deleteWatchListViewModel
{
    func deleteWatchList(user_id: String, video_id: String, completion: @escaping (Result<deleteWatchListResponse, Error>) -> Void)
    {
        let request = deleteWatchListRequest(user_id: user_id, video_id: video_id)
        
        APIManager.shared.deleteWatchList(request: request, responseModelType: deleteWatchListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
       
    }
}
