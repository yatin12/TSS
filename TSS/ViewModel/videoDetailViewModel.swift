//
//  videoDetailViewModel.swift
//  TSS
//
//  Created by apple on 08/07/24.
//

import Foundation
class videoDetailViewModel
{
    func VideoDetailApi(userId: String, videoId: String, completion: @escaping (Result<videoDetailResponse, Error>) -> Void)
    {
        let request = videoDetailRequest(userId: userId, videoId: videoId, postType: strSelectedPostName)
        
        APIManager.shared.VideoDetailApi(request: request, responseModelType: videoDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
