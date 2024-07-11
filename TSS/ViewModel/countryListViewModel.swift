//
//  countryListViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
class countryListViewModel
{
    func getCountryList(completion: @escaping (Result<countryListResponse, Error>) -> Void)
    {
        APIManager.shared.getCountryList(responseModelType: countryListResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
}
