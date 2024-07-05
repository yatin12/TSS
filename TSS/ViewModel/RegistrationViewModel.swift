//
//  RegistrationViewModel.swift
//  TSS
//
//  Created by apple on 03/07/24.
//

import Foundation
import UIKit
class RegistrationViewModel
{
    weak var vc: RegistrationVC?
    
    func validationForRegistration(userName: String, email: String, password: String, confirmPassword: String) -> Bool
    {
        var isValidate: Bool = false
       
        if !ValidationConstants.isNotEmptyEmail(userName)
        {
            //Email is empty or contains only whitespace characters
            self.showSimpleAlert(message: "\(AlertMessages.BlankUserNm)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.isNotEmptyEmail(email)
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
        else if !ValidationConstants.isNotEmptyPassword(confirmPassword) {
            self.showSimpleAlert(message: "\(AlertMessages.BlankConfirmPassword)", in: vc!)

            isValidate = false
        }
        else if !ValidationConstants.isValidPassword(confirmPassword) {
            self.showSimpleAlert(message: "\(AlertMessages.ConfirmPasswordLength)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.arePasswordsMatching(newPassword: password, confirmPassword: confirmPassword) {
            self.showSimpleAlert(message: "\(AlertMessages.MatchPasswordReg)", in: vc!)
            isValidate = false
        }
        else
        {
            isValidate = true
        }
        
    
        return isValidate
    }
    func registrationUser(first_name: String, last_name: String, username: String, email: String, password: String, dob: String, gender: String, country: String, device_token: String, completion: @escaping (Result<registrationResponse, Error>) -> Void)
    {
        let request =  RegistrationRequest(first_name: first_name, last_name: last_name, username: username, email: email, password: password, dob: dob, gender: gender, country: country, device_token: device_token)
        
        APIManager.shared.registrationUser(request: request, responseModelType: registrationResponse.self) { result in
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
