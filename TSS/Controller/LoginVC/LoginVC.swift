//
//  LoginVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class LoginVC: UIViewController {
    var isRememberMeOn: Bool = false
    private let objLoginViewModel = LoginViewModel()

    @IBOutlet weak var btnRememberOutlt: UIButton!
    @IBOutlet weak var lblLowerDeclaration: TappableLabel!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var imgRemember: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
}
//MARK: UIViewLife Cycle Methods
extension LoginVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCredentials()
        self.setUpUIRegisterLabel()
        self.setUpUIForLowerDeclaration()
        self.setUpPlaceholderColor()
        self.passViewControllerObjToViewModel()
    }
   

}
//MARK: General Methods
extension LoginVC
{
    func passViewControllerObjToViewModel()
    {
        objLoginViewModel.vc = self
    }
    func setUpPlaceholderColor()
    {
        GenericFunction.setPlaceholderColor(for: txtEmail)
        GenericFunction.setPlaceholderColor(for: txtPassword)
        imgRemember.isHidden = true
        
    }
    func setUpUIRegisterLabel()
    {
        let attributedString = NSMutableAttributedString(string: "Not registered yet ?", attributes: lightAttributes)
        attributedString.append(NSAttributedString(string: " ", attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: "Register", attributes: mediumAttributes))
        lblRegister.attributedText = attributedString
    }
    func setUpUIForLowerDeclaration() {
        let text = "By registering, you agree to Streamvid's Terms of Use and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: text, attributes: lightAttributes)
        
        let termsRange = (text as NSString).range(of: "Terms of Use")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: privacyRange)
        
        lblLowerDeclaration.attributedText = attributedString
        
        lblLowerDeclaration.onTap = { range, text in
            if text == "Terms of Use" {
                self.termsTapped()
            } else if text == "Privacy Policy" {
                self.privacyTapped()
            }
        }
    }
    @objc func termsTapped() {
        // Handle Terms of Use tap
        print("Terms of Use tapped")
    }
    
    @objc func privacyTapped() {
        // Handle Privacy Policy tap
        print("Privacy Policy tapped")
    }
    private func updateBorder(for textField: UITextField, isEditing: Bool) {
        
        
        if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
//            if isEditing {
//                txtPassword.text = ""
//            }
        } else if textField == txtPassword {
            vwPassword.layer.borderColor = isEditing ? highlightColor : clearColor
            vwPassword.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
//            if isEditing {
//                txtEmail.text = ""
//            }
        }
    }
    func saveCredentials(username: String, password: String) {
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "SavedUsername")
        defaults.set(password, forKey: "SavedPassword")
        defaults.set(isRememberMeOn, forKey: "isRememberMeOn")
    }
    
    func loadCredentials() {
        let defaults = UserDefaults.standard
        isRememberMeOn = defaults.bool(forKey: "isRememberMeOn")
        
        if isRememberMeOn {
            txtEmail.text = defaults.string(forKey: "SavedUsername")
            txtPassword.text = defaults.string(forKey: "SavedPassword")
        }
    }
    
    func clearCredentials() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "SavedUsername")
        defaults.removeObject(forKey: "SavedPassword")
        defaults.set(false, forKey: "isRememberMeOn")
    }
    
    func updateRememberMeButtonAppearance() {
        
        if self.imgRemember.tag == 0 {
            self.imgRemember.tag = 1
            self.isRememberMeOn = true
            self.imgRemember.isHidden = false
            
        } else {
            self.imgRemember.tag = 0
            self.isRememberMeOn = false
            self.imgRemember.isHidden = true
        }
    }
}
//MARK: IBAction
extension LoginVC
{
    @IBAction func btnRegisterTapped(_ sender: Any) {

        NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "RegistrationVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSignInTapped(_ sender: Any) {
        self.validationForLogin()
    }
    @IBAction func btnLostPasswordTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "ForgotPasswordVC", from: navigationController!, animated: true)

        
    }
    @IBAction func btnRememberTapped(_ sender: Any) {
       // isRememberMeOn.toggle()
        updateRememberMeButtonAppearance()
    }
}
//MARK: UITextFieldDelegate
extension LoginVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)

    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)

    }
}
//MARK: API Call
extension LoginVC
{
    func validationForLogin()
    {
        var isValidate: Bool = false
        isValidate =  objLoginViewModel.validationForLogin(email: txtEmail.text ?? "", password: txtPassword.text ?? "")
        if isValidate {
            self.apiCallLogin()
        }

    }
    func apiCallLogin()
    {
        let deviceId: String = AppUserDefaults.object(forKey: "DEVICETOKEN") as? String ?? "2222"

        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objLoginViewModel.loginUser(email: txtEmail.text ?? "", password: txtPassword.text ?? "", device_token: deviceId) { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    
                    if ((loginResponse.settings?.success) != nil) == true
                    {
                        if self.isRememberMeOn {
                            self.saveCredentials(username: self.txtEmail.text ?? "" , password: self.txtPassword.text ?? "")
                               } else {
                                   self.clearCredentials()
                               }
                       
                        UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserLoggedIn")

                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.settings?.authorization ?? "")", forKey: "AUTHTOKEN")


                        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "HomeNev", from: self.navigationController!, animated: true)
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(loginResponse.settings?.message ?? "")")

                    }
                   

                    
                   // self.apiCallAddFCMToken()
                    
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
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")

        }
    }
}
