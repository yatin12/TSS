//
//  getLiveShowDetailsViewModel.swift
//  TSS
//
//  Created by khushbu bhavsar on 28/08/24.
//

import Foundation
class getLiveShowDetailsViewModel
{
    func liveShowDetails(userId: String, postId: String, completion: @escaping (Result<liveShowDetailResponse, Error>) -> Void)
    {
        let request = lievShowDetailRequest(userId: userId, postId: postId)
       // let request = lievShowDetailRequest(userId: "53", postId: postId) //Khushbu_Change

       
        APIManager.shared.getLiveShowDetailApi(request: request, responseModelType: liveShowDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
       
    }
}
