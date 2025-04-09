//
//  APIManager.swift
//  Uveaa Solar
//
//  Created by apple on 02/02/24.
//

import Foundation
import Alamofire


enum APIError: Error {
    case unknown
    case networkError(AFError)
    case httpError(statusCode: Int, errorMessage: String?)
}


class APIManager {
    static let shared = APIManager()
    let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
    
    private init() {}
    //MARK: Login API
    func loginUser<T: Decodable>(request: LoginRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let URLstr: String = "\(APIConfig.baseURL+loginEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: nil, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func AddFCMToken<T: Decodable>(request: AddFCMTokenRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let URLstr: String = "\(APIConfig.baseURL+addFCMTokenEndpoint)"
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]
        
        Logger.logRequest(url: URLstr, method: "Post", headers: nil, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func registrationUser<T: Decodable>(request: RegistrationRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let URLstr: String = "\(APIConfig.baseURL+registerEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: nil, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func blogCategoryList<T: Decodable>(request: blogCategoryRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+blog_categoriesEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func getNewsListByCategory<T: Decodable>(request: blogByCategoryRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+get_blogs_by_categoryEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func blogDetailsList<T: Decodable>(request: blogDetailsRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+blog_details_by_pageidEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func favBlogList<T: Decodable>(request: favBlogRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+get_favourite_listEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func WatchBlogList<T: Decodable>(request: watchListRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+get_watchlistEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func videoList<T: Decodable>(request: videoListRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+getVideoListEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func talkShowList<T: Decodable>(request: talkShowListRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+getTalkShowListEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func VideoDetailApi<T: Decodable>(request: videoDetailRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+e_videoDetailEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func getProfileDetails<T: Decodable>(request: getProfileRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+getProfileEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func updateProfile<T: Decodable>(profileImgData: Data?, userId: String, userName: String, email: String, phone: String, password: String, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {

        // API endpoint URL
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        let URLstr: String = "\(APIConfig.baseURL+updateProfileEndpoint)"
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)

        // Parameters for the form data
        let parameters: Parameters = [
            "userId": userId,
            "userName": userName,
            "email": email,
            "phone": phone,
            "password": password
        ]


        // Start Alamofire multipart form data request
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }

            do {

                if let imageData1 = profileImgData {
                    multipartFormData.append(imageData1, withName: "imageUrl", fileName: "profilePic.jpeg", mimeType: "image/jpeg")
                }
                
            }
        }, to: URLstr, headers: customHeaders)
        .validate()
        .responseDecodable(of: T.self) { response in
            Logger.logResponse(url: URLstr, response: response)

            if let data = response.data {
                print(String(data: data, encoding: .utf8) ?? "Unable to print data")
            }

            do {
                let result = try response.result.get() // This line will throw an error if the decoding fails
                completion(.success(result))
            } catch {
                // Handle decoding error here
                print("Error decoding data: \(error)")
                self.handleFailureResponse(response, completion: completion)
            }
        }
     
    }
    func getCountryList<T: Decodable>(responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {

        let apiUrl: String = "\(APIConfig.baseURL + countryListEndpoint)"
        let URLstr: String = "\(apiUrl)"
        
        Logger.logRequest(url: URLstr, method: "Get", headers: nil, body: nil)

        AF.request(URLstr, method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)

                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }

                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                 //   print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func addWatchList<T: Decodable>(request: addWatchListRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+addWatchlistEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func deleteWatchList<T: Decodable>(request: deleteWatchListRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+deleteWatchlistEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func sendContactDetails<T: Decodable>(request: sendContactRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+sendContactDetailsEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func videoRateSend<T: Decodable>(request: videoRateRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+videoRateEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func membershipPlanList<T: Decodable>(request: membershipRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+membershipPlanEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func postSubscriptionCancelledInfo(userID: String, isCancelled: String,  completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL
        let urlString = "\(APIConfig.baseURL+subscriptionPurchaseEndpoint)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Set up the request parameters
        let parameters: [String: Any] = [
            "userID": userID,
            "isCancelled": isCancelled
        ]
        
        // Set up the headers
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""

        let headers: HTTPHeaders = [
            "Authorization": authToken,
            "Content-Type": "application/json"
        ]
        
        // Make the request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func postUpcomingEventPurchaseInfo(userID: String, postid: String, productId: String, transactionIdentifier: String, transactionDate: String, transactionState: String, productPrice: String, productPriceLocal: String, productPurchaseCurrencyCode: String, isCancelled: String,  completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL
        let urlString = "\(APIConfig.baseURL+UpcomingEventPurchaseEndpoint)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Set up the request parameters
        let parameters: [String: Any] = [
            "userID": userID,
            "postid": postid,
            "productId": productId,
            "transactionIdentifier": transactionIdentifier,
            "transactionDate": transactionDate,
            "transactionState": transactionState,
            "productPrice": productPrice,
            "productPriceLocal": productPriceLocal,
            "productPurchaseCurrencyCode": productPurchaseCurrencyCode,
            "isCancelled": isCancelled
        ]
        
        // Set up the headers
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""

        let headers: HTTPHeaders = [
            "Authorization": authToken,
            "Content-Type": "application/json"
        ]
        
        // Make the request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func postSubscriptionInfoNew(userID: String, productId: String, transactionIdentifier: String, transactionDate: String, transactionState: String, productPrice: String, productPriceLocal: String, productPurchaseCurrencyCode: String, planType: String, isCancelled: String,  completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL
        let urlString = "\(APIConfig.baseURL+subscriptionPurchaseEndpoint)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Set up the request parameters
        let parameters: [String: Any] = [
            "userID": userID,
            "productId": productId,
            "transactionIdentifier": transactionIdentifier,
            "transactionDate": transactionDate,
            "transactionState": transactionState,
            "productPrice": productPrice,
            "productPriceLocal": productPriceLocal,
            "productPurchaseCurrencyCode": productPurchaseCurrencyCode,
            "planType": planType,
            "isCancelled": isCancelled
        ]
        
        // Set up the headers
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""

        let headers: HTTPHeaders = [
            "Authorization": authToken,
            "Content-Type": "application/json"
        ]
        
        // Make the request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    /*
    func postSubscriptionInfo<T: Decodable>(request: subscriptionPurchaseRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]
        
        let URLstr: String = "\(APIConfig.baseURL+subscriptionPurchaseEndpoint)"
        
        
        Logger.logRequest(url: URLstr, method: "POST", headers: customHeaders, body: nil)
        
        AF.request(URLstr, method: .post, parameters: request, encoder: URLEncodedFormParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
                
            }
    }
    */
    func VideoFavUnFav<T: Decodable>(request: LikeVideoRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+favVideoEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func searchList<T: Decodable>(request: searchRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+searchEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func forgotPasswordApi<T: Decodable>(request: ForgotPasswordRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+forgotPasswordEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func deleteAccountApi<T: Decodable>(request: deleteAccountRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+deleteAccountEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func getUpcomingEventsList<T: Decodable>(request: upcomingRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+UpcomingEventsEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func getHomeList<T: Decodable>(request: HomeRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+HomeEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func getLiveShowDetailApi<T: Decodable>(request: lievShowDetailRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+liveShowDetailsEndpoint)"
        
        
        /*
        let URLstr: String = "https://test.fha.nqn.mybluehostin.me/wp-json/pmpro/v1/get-liveshow-detail"
        
        let authToken: String = "Basic YWRtaW46SmNteHoyMTY0OTAj"
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]
        */
        
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    func logoutApi<T: Decodable>(request: logoutRequest, responseModelType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let authToken: String = AppUserDefaults.object(forKey: "AUTHTOKEN") as? String ?? ""
        
        let customHeaders: HTTPHeaders = [
            "Authorization": authToken
        ]

        
        let URLstr: String = "\(APIConfig.baseURL+logoutEndpoint)"
        
        Logger.logRequest(url: URLstr, method: "Post", headers: customHeaders, body: nil)
        AF.request(URLstr, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: customHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                Logger.logResponse(url: URLstr, response: response)
                
                if let data = response.data {
                    print(String(data: data, encoding: .utf8) ?? "Unable to print data")
                }
                
                do {
                    let result = try response.result.get() // This line will throw an error if the decoding fails
                    completion(.success(result))
                } catch {
                    // Handle decoding error here
                    print("Error decoding data: \(error)")
                    self.handleFailureResponse(response, completion: completion)
                }
            }
    }
    //MARK: Error Handler
    func handleFailureResponse<T: Decodable>(_ response: DataResponse<T, AFError>, completion: @escaping (Result<T, APIError>) -> Void) {
        if let statusCode = response.response?.statusCode {
            var errorMessage: String?
            
            if let data = response.data, let message = String(data: data, encoding: .utf8) {
                errorMessage = message
            }
            
            let errorInfo = APIError.httpError(statusCode: statusCode, errorMessage: errorMessage)
            completion(.failure(errorInfo))
        } else {
            completion(.failure(APIError.unknown))
        }
    }
}
class ErrorHandlingUtility {
    
    static func handleAPIError(_ error: Error, in viewController: UIViewController) {
        if let apiError = error as? APIError {
            switch apiError {
            case .httpError(let statusCode, let errorMessage):
                handleHTTPError(statusCode: statusCode, errorMessage: errorMessage, in: viewController)
                AlertUtility.presentSimpleAlert(in: viewController, title: "", message: "\(AlertMessages.ErrorAlertMsg)")

            default:
                // Handle other types of API errors if needed
               // print("API Error: \(apiError)")
                AlertUtility.presentSimpleAlert(in: viewController, title: "", message: "\(apiError.localizedDescription)")
                
            }
        } else {
            // Handle other types of errors
           // print("Unexpected error: \(error)")
            AlertUtility.presentSimpleAlert(in: viewController, title: "", message: "\(error.localizedDescription)")
        }
    }
    
    private static func handleHTTPError(statusCode: Int, errorMessage: String?, in viewController: UIViewController) {
        if let errorMessageData = errorMessage?.data(using: .utf8) {
            do {
                let errorJSON = try JSONSerialization.jsonObject(with: errorMessageData, options: []) as? [String: Any]
                if let message = errorJSON?["message"] as? String {
                   // print("HTTP Error \(statusCode): \(message)")
                    AlertUtility.presentSimpleAlert(in: viewController, title: "", message: "\(message)")
                } else {
                    print("HTTP Error \(statusCode): Unknown error")
                }
            } catch {
                print("Error parsing error message JSON: \(error)")
            }
        } else {
            print("HTTP Error \(statusCode): Unknown error")
        }
    }
}


