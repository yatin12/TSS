//
//  LoginVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class LoginVC: UIViewController {
    //  - Variables - 
    
    var isRememberMeOn: Bool = false
    private let objLoginViewModel = LoginViewModel()
    private let objAddFCMTokenViewModel = AddFCMTokenViewModel()

    //  - Outlets - 
    
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgPassVisibility: UIImageView!
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
        self.setUpUIRegisterLabel()
        self.setUpUIForLowerDeclaration()
        self.setUpPlaceholderColor()
        self.loadCredentials()
        self.setTextfileds()
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
        
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "ThemeFontColor") ?? .black, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "ThemeFontColor") ?? .black, range: privacyRange)
       
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
        isFromTermsViewSetting = false
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TermsConditionVC", from: navigationController!, animated: true)
    }
    
    @objc func privacyTapped() {
        // Handle Privacy Policy tap
        print("Privacy Policy tapped")
        isFromPrivacyViewSetting = false
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "PrivacyPolicyVC", from: navigationController!, animated: true)
    }
    func setTextfileds()
    {
        txtEmail.iq.toolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        txtPassword.iq.toolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))

    }
    @objc func doneButtonClicked(_ sender: UIButton)
    {
        print(sender.tag)
        if sender.tag == 0 {
          updateBorder(for: txtEmail, isEditing: true)
        }
        else if sender.tag == 1 {
            updateBorder(for: txtPassword, isEditing: true)
        }
    }
    private func updateBorder(for textField: UITextField, isEditing: Bool) {
        if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : DefaultBorderColor
            lblEmail.textColor = isEditing ? highlightColor_Lbl : DefaultBorderColor_Lbl
            
            vwPassword.layer.borderColor = isEditing ? DefaultBorderColor : highlightColor
            lblPassword.textColor = isEditing ? DefaultBorderColor_Lbl : highlightColor_Lbl

        } else if textField == txtPassword {
            vwPassword.layer.borderColor = isEditing ? highlightColor : DefaultBorderColor
            lblPassword.textColor = isEditing ? highlightColor_Lbl : DefaultBorderColor_Lbl

            vwEmail.layer.borderColor = isEditing ? DefaultBorderColor : highlightColor
            lblEmail.textColor = isEditing ? DefaultBorderColor_Lbl : highlightColor_Lbl

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
            imgRemember.isHidden = false
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
    @IBAction func btnSigninAsGuestUserTapped(_ sender: Any) {
        UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

        
        UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserLoggedIn")
        UserDefaultUtility.saveValueToUserDefaults(value: "GuestUser", forKey: "USERROLE")
        UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "USERID")
        UserDefaultUtility.saveValueToUserDefaults(value: "Guest YWRtaW46OTIpbSleenBndjJ0RkVVc3hES3FXVXVw", forKey: "AUTHTOKEN")
        
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "HomeNev", from: self.navigationController!, animated: true)
    }
    @IBAction func btnPasswordVisibilityTapped(_ sender: Any) {
        txtPassword.isSecureTextEntry.toggle()
           if txtPassword.isSecureTextEntry {
               imgPassVisibility.image = UIImage(named: "icn_Eye")
           } else {
               imgPassVisibility.image = UIImage(named: "icn_Eye_Slash")
           }
    }
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
        var deviceId: String = AppUserDefaults.object(forKey: "DEVICETOKEN") as? String ?? ""
        if deviceId == ""
        {
            deviceId = "2222"
        }
        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objLoginViewModel.loginUser(email: txtEmail.text ?? "", password: txtPassword.text ?? "", device_token: deviceId) { result in
               
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    
                    //                    if ((loginResponse.settings?.success) != nil) == true
                    if loginResponse.settings?.success == true
                    {
                        if self.isRememberMeOn {
                            self.saveCredentials(username: self.txtEmail.text ?? "" , password: self.txtPassword.text ?? "")
                        } else {
                            self.clearCredentials()
                        }
                        
                        let strSubscriptionName = loginResponse.data?.membershipLevel?.name ?? "\(SubscibeUserType.free)"
                        if strSubscriptionName == SubscibeUserType.free {
                            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")
                        }
                        else if strSubscriptionName == SubscibeUserType.basic {
                            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.basic)", forKey: "SubscribedUserType")
                        }
                        else if strSubscriptionName == SubscibeUserType.premium {
                            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.premium)", forKey: "SubscribedUserType")
                        }
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.data?.userNicename ?? "")", forKey: "UserName")
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.data?.userEmail ?? "")", forKey: "UserEmail")


                        
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.data?.id ?? "0")", forKey: "USERID")
                        
                        
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.settings?.authorization ?? "")", forKey: "AUTHTOKEN")
                      
                        self.apiCallAddFCMToken()
                    }
                    else
                    {
                        KVSpinnerView.dismiss()
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(loginResponse.settings?.message ?? "")")
                        
                    }
                    
                case .failure(let error):
                    KVSpinnerView.dismiss()
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
    func apiCallAddFCMToken()
    {
        var deviceId: String = AppUserDefaults.object(forKey: "DEVICETOKEN") as? String ?? ""
        if deviceId == ""
        {
            deviceId = "111"
        }
        var fcmToken: String = AppUserDefaults.object(forKey: "FCMTOKEN") as? String ?? ""
        if fcmToken == ""
        {
            fcmToken = "222"
        }
        let userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        
        if Reachability.isConnectedToNetwork()
        {
           // KVSpinnerView.show()
            objAddFCMTokenViewModel.addFCMToken(deviceId: deviceId, fcmToken: fcmToken, userId: userId) { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(_):
                    // Handle successful
                    
                    print("done")
                    
                    
                    UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserLoggedIn")
                    
                    UserDefaultUtility.saveValueToUserDefaults(value: "SignInUser", forKey: "USERROLE")
                    
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "HomeNev", from: self.navigationController!, animated: true)
                    
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
