//
//  blogDetailsViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation

class blogDetailsViewModel
{
    func blogDetails(postId: String, userId: String, completion: @escaping (Result<blogDetailsResponse, Error>) -> Void)
    {
        let request = blogDetailsRequest(postId: postId, userId: userId)
        
        APIManager.shared.blogDetailsList(request: request, responseModelType: blogDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }

}
