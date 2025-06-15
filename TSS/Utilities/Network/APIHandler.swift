
import Foundation
import Alamofire
import UIKit

// Add an ErrorResponse struct to decode error messages
struct ErrorResponse: Decodable {
    let message: String?
}

enum APIErrorSwiftUI: Error {
    case networkError(String)
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message), .serverError(let message):
            return message
        }
    }
}

struct ErrorHandlingUtilitySwiftUI {
    /*
    static func handleFailureResponse<T: Decodable>(response: DataResponse<T, AFError>) -> APIErrorSwiftUI {
        if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return .serverError(errorResponse.message ?? "Unknown server error")
        }
        return .networkError(response.error?.localizedDescription ?? "An unknown error occurred")
    }
    */
    static func handleFailureResponse<T: Decodable>(response: DataResponse<T, AFError>) -> APIErrorSwiftUI {
        if let data = response.data {
            // Print the raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw error response: \(rawString)")
            }
            
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                return .serverError(errorResponse.message ?? "Unknown server error")
            }
        }
        return .networkError(response.error?.localizedDescription ?? "An unknown error occurred")
    }
}

struct APIHandler {
    static let shared = APIHandler()
    private init() {}

    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure:
                        let apiError = ErrorHandlingUtilitySwiftUI.handleFailureResponse(response: response)
                        continuation.resume(throwing: apiError)
                    }
                }
        }
    }
}
extension Encodable {
    func parseHandler() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
}
