//
//  upcomingEventViewModel.swift
//  TSS
//
//  Created by khushbu bhavsar on 06/09/24.

import Foundation
class upcomingEventViewModel
{
    func getUpcomingList(userId: String, pagination_number: String, completion: @escaping (Result<upcomingEventResponse, Error>) -> Void) {

        let request = upcomingRequest(userId: userId, pagination_number: pagination_number)
        
        APIManager.shared.getUpcomingEventsList(request: request, responseModelType: upcomingEventResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
