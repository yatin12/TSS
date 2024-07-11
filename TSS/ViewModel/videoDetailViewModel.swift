//
//  videoDetailViewModel.swift
//  TSS
//
//  Created by apple on 08/07/24.
//

import Foundation
class videoDetailViewModel
{
    func videoDetail(userId: String, videoId: String, completion: @escaping (Result<videoDetailResponse, Error>) -> Void)
    {
        let request = videoDetailRequest(userId: userId, videoId: videoId)
        
        APIManager.shared.VideoDetail(request: request, responseModelType: videoDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
