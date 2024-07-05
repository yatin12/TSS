//
//  Logger.swift
//  Uveaa Solar
//
//  Created by apple on 07/02/24.
//

import Foundation
import Alamofire



class Logger {

    static func logRequest(url: String, method: String, headers: HTTPHeaders?, body: Data?) {
        #if DEBUG
        if currentEnvironment == .beta  {
          //  print("Request - Environment: \(currentEnvironment.rawValue)")
            print("URL: \(url)")
            print("Method: \(method)")
            print("Headers: \(headers ?? [:])")
            print("Body: \(String(describing: body))")
        }
        #endif
    }
    static func logResponse<T>(url: String, response: DataResponse<T, AFError>) {
         #if DEBUG
         if currentEnvironment == .beta  {
             print("Response - Environment: \(currentEnvironment)")
             print("URL: \(url)")
             
             if let statusCode = response.response?.statusCode {
                 print("Status Code: \(statusCode)")
             }
             
             if let data = response.data {
                 print("Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
             }

             if let error = response.error {
                 print("Error: \(error.localizedDescription)")
             }
         }
         #endif
     }

}

