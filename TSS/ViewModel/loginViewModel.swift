//
//  loginViewModel.swift
//  TSS
//
//  Created by apple on 02/07/24.
//

import Foundation
import UIKit

class LoginViewModel
{
    weak var vc: LoginVC?

    func validationForLogin(email: String, password: String) -> Bool
    {
        var isValidate: Bool = false
        if !ValidationConstants.isNotEmptyEmail(email)
        {
            //Email is empty or contains only whitespace characters
            self.showSimpleAlert(message: "\(AlertMessages.BlankEmail)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.isValidEmail(email)
        {
            //Not Valid Email
            self.showSimpleAlert(message: "\(AlertMessages.InvalidEmail)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.isNotEmptyPassword(password)
        {
            //Password is empty or contains only whitespace characters
            self.showSimpleAlert(message: "\(AlertMessages.BlankPassword)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.isValidPassword(password)
        {
            //Not Valid password
            self.showSimpleAlert(message: "\(AlertMessages.PasswordLength)", in: vc!)
            isValidate = false
        }
        else
        {
            isValidate = true
        }
        return isValidate
    }
    
    func loginUser(email: String, password: String, device_token: String, completion: @escaping (Result<loginResponse, Error>) -> Void) {

        
        let request = LoginRequest(email: email, password: password, device_token: device_token)
        
        APIManager.shared.loginUser(request: request, responseModelType: loginResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError as Error))
            }
        }
    }
  
    func showSimpleAlert(message: String, in viewController: UIViewController) {
            AlertUtility.presentSimpleAlert(in: viewController, title: "", message: "\(message)")
        }
    func showAlert(message: String, in viewController: UIViewController) {
          AlertUtility.presentAlert(in: viewController, title: "", message: "\(message)", options: "Option 1", "Option 2") { index in
             // print("Selected option index: \(index)")
          }
      }
}
