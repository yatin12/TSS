//
//  updateProfileViewModel.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import Foundation
import UIKit

class updateProfileViewModel
{
    weak var vc: ProfileVC?
    
    func validationForProfile(password: String, confirmPassword: String) -> Bool
    {
        var isValidate: Bool = false
       
        if !ValidationConstants.isNotEmptyPassword(password)
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
    
    func updateProfile(profileImgData: Data?, userId: String, userName: String, email: String, phone: String, password: String, completion: @escaping (Result<GetProfileResponse, Error>) -> Void)
    {
        APIManager.shared.updateProfile(profileImgData: profileImgData, userId: userId, userName: userName, email: email, phone: phone, password: password, responseModelType: GetProfileResponse.self) { result in
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
