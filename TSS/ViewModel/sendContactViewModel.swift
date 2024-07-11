//
//  sendContactViewModel.swift
//  TSS
//
//  Created by apple on 11/07/24.
//

import Foundation
import UIKit
class sendContactViewModel
{
    weak var vc: ContactUSVC?
    func validationForContact(email: String, your_name: String, message: String) -> Bool
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
        else if !ValidationConstants.isNotEmptyName(your_name)
        {
            //Password is empty or contains only whitespace characters
            self.showSimpleAlert(message: "\(AlertMessages.BlankName)", in: vc!)
            isValidate = false
        }
        else if !ValidationConstants.isNotEmptyName(message)
        {
            //Password is empty or contains only whitespace characters
            self.showSimpleAlert(message: "\(AlertMessages.BlankMessage)", in: vc!)
            isValidate = false
        }
        else
        {
            isValidate = true
        }
        return isValidate
    }
    func sendContactDetails(user_id: String, your_name: String, email: String, message: String, type: String, completion: @escaping (Result<sendContactResponse, Error>) -> Void)
    {
        let request = sendContactRequest(user_id: user_id, your_name: your_name, email: email, message: message, type: type)
        
        APIManager.shared.sendContactDetails(request: request, responseModelType: sendContactResponse.self) { result in
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
