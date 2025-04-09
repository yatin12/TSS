//
//  ForgotPasswordVC.swift
//  TSS
//
//  Created by apple on 04/07/24.
//

import UIKit
import KVSpinnerView

class ForgotPasswordVC: UIViewController {
    
    //  - Variables - 
    private let objForgotPasswordViewModel = ForgotPasswordViewModel()

    //  - Outlets - 
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var vwEmail: UIView!
    
}
extension ForgotPasswordVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUIRegisterLabel()
        self.setUpPlaceholderColor()
        self.passViewControllerObjToViewModel()
    }
    


}
extension ForgotPasswordVC
{
    func passViewControllerObjToViewModel()
    {
        objForgotPasswordViewModel.vc = self
    }
    func setUpUIRegisterLabel()
    {
        let attributedString = NSMutableAttributedString(string: "Back to", attributes: lightAttributes)
        attributedString.append(NSAttributedString(string: " ", attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: "Login", attributes: mediumAttributes))
        lblLogin.attributedText = attributedString
    }
    func setUpPlaceholderColor()
    {
        GenericFunction.setPlaceholderColor(for: txtEmail)
        
    }
}
//MARK: UITextFieldDelegate
extension ForgotPasswordVC: UITextFieldDelegate
{
    private func updateBorder(for textField: UITextField, isEditing: Bool) {
        if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : DefaultBorderColor
            //vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)

    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)

    }
}
extension ForgotPasswordVC
{
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.validationForForgotPassword()
    }
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: API Call
extension ForgotPasswordVC
{
    func validationForForgotPassword()
    {
        var isValidate: Bool = false
                
        isValidate = objForgotPasswordViewModel.validationForForgotPassword(email: txtEmail.text ?? "")
        if isValidate {
            self.apiCallForgotPassword()
        }

    }
    func apiCallForgotPassword()
    {
        KVSpinnerView.show()
        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
            objForgotPasswordViewModel.sendForgotPassword(email: txtEmail.text ?? "") { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    
                    if loginResponse.settings?.success == true
                    {
                        AlertUtility.presentAlert(in: self, title: "", message: "\(loginResponse.settings?.message ?? "")", options: "Ok") { option in
                            switch(option) {
                            case 0:
                                self.navigationController?.popViewController(animated: true)
                                break
                           
                            default:
                                break
                            }
                        }
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(loginResponse.settings?.message ?? "")")
                    }
                    
                    
                    
                case .failure(let error):
                    // Handle failure
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        // print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                        
                    }
                }
            }
        }
        else
        {
            KVSpinnerView.dismiss()
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
            
        }
    }
}
