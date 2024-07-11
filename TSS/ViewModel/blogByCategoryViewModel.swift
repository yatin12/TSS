//
//  blogByCategoryViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
class blogByCategoryViewModel
{
    func blogByCategoryList(category_id: String, userId: String, completion: @escaping (Result<blogByCategoryResponse, Error>) -> Void) {

        let request = blogByCategoryRequest(category_id: category_id, userId: userId)
        
        APIManager.shared.blogByCategoryList(request: request, responseModelType: blogByCategoryResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
        
    }
}
