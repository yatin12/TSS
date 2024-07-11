//
//  talkShowViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
class talkShowViewModel
{
    func takShowList(userId: String, category_id: String, completion: @escaping (Result<talkShowListResponse, Error>) -> Void)
    {
        let request = talkShowListRequest(userId: userId, category_id: category_id)
        
        APIManager.shared.talkShowList(request: request, responseModelType: talkShowListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
    

