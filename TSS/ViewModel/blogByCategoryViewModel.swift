//
//  blogByCategoryViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation
class blogByCategoryViewModel
{
    func getNewsListByCategory(category_id: String, userId: String, pagination_number: String, completion: @escaping (Result<blogByCategoryResponse, Error>) -> Void) {

        let request = blogByCategoryRequest(category_id: category_id, userId: userId, pagination_number: pagination_number)
        
        APIManager.shared.getNewsListByCategory(request: request, responseModelType: blogByCategoryResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
        
    }
}
