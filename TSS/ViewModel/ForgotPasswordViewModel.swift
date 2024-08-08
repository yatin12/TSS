//
//  ForgotPasswordViewModel.swift
//  TSS
//
//  Created by apple on 07/08/24.
//

import Foundation
import UIKit
class ForgotPasswordViewModel
{
    weak var vc: ForgotPasswordVC?

    func validationForForgotPassword(email: String) -> Bool
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
        
        else
        {
            isValidate = true
        }
        return isValidate
    }
    
    func sendForgotPassword(email: String, completion: @escaping (Result<ForgotPasswordResponse, Error>) -> Void)
    {
        let request = ForgotPasswordRequest(email: email)
        APIManager.shared.forgotPasswordApi(request: request, responseModelType: ForgotPasswordResponse.self) { result in
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
}
