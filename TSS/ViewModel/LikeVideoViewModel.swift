//
//  LikeVideoViewModel.swift
//  TSS
//
//  Created by apple on 17/07/24.
//

import Foundation

class LikeVideoViewModel
{
    func videoFavUnFav(user_id: String, video_id: String, action: String, Type: String, completion: @escaping (Result<favouriteResponse, Error>) -> Void)
    {
        let request = LikeVideoRequest(user_id: user_id, video_id: video_id, action: action, Type: Type)
        APIManager.shared.VideoFavUnFav(request: request, responseModelType: favouriteResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
