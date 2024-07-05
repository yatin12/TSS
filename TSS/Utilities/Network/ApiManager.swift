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


