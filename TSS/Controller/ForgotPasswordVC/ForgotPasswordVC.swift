//
//  ForgotPasswordVC.swift
//  TSS
//
//  Created by apple on 04/07/24.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //  - Variables - 
    
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
    }
    


}
extension ForgotPasswordVC
{
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
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
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
    }
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
