//
//  videoRateViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
class videoRateViewModel
{
    func submitVideoRate(user_id: String, video_id: String, rating: String, comment: String, completion: @escaping (Result<videoRateResponse, Error>) -> Void )
    {
        let request = videoRateRequest(userId: user_id, video_id: video_id, rating: rating, comment: comment)
        APIManager.shared.videoRateSend(request: request, responseModelType: videoRateResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
