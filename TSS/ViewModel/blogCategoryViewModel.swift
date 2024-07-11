//
//  blogCategoryViewModel.swift
//  TSS
//
//  Created by apple on 05/07/24.
//

import Foundation

class blogCategoryViewModel
{
    func blogCategoryList(userId: String, categortType: String, completion: @escaping (Result<blogCategoryResponse, Error>) -> Void) {

        let request = blogCategoryRequest(userId: userId, categoryType: categortType)
        APIManager.shared.blogCategoryList(request: request, responseModelType: blogCategoryResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
