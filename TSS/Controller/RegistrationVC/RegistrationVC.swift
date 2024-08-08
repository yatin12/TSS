//
//  RegistrationVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class RegistrationVC: UIViewController {
    //  - Variables - 
    private let objRegistrationViewModel = RegistrationViewModel()
    var strSelectedGender: String = ""
    
    //  - Outlets - 
    @IBOutlet weak var imgEyeConfPass: UIImageView!
    @IBOutlet weak var imgEyePass: UIImageView!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var lblLowerDeclaration: TappableLabel!
    @IBOutlet weak var lblLogin: UILabel!
    
    @IBOutlet weak var txtGendar: UITextField!
    @IBOutlet weak var vwCountry: UIView!
    @IBOutlet weak var vwGendar: UIView!
    
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var vwBirthday: UIView!
    @IBOutlet weak var txtConfPassword: UITextField!
    @IBOutlet weak var vwConfPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtUserNm: UITextField!
    @IBOutlet weak var vwUserNm: UIView!
    @IBOutlet weak var txtLastNm: UITextField!
    @IBOutlet weak var vwLastNm: UIView!
    @IBOutlet weak var txtFristNm: UITextField!
    @IBOutlet weak var vwFristNm: UIView!
}
//MARK: UIViewLife Cycle Methods
extension RegistrationVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passViewControllerObjToViewModel()
        self.setUpPlaceholderColor()
        self.setUpUIRegisterLabel()
        self.setUpUIForLowerDeclaration()
       
    }
}
//MARK: General Methods
extension RegistrationVC
{
    func openDatePicker()
    {
        let storyboard = UIStoryboard(name: storyboardKey.IntroScreen, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OpenDatePickerVC") as! OpenDatePickerVC
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false)
    }
    func setUpPlaceholderColor()
    {
        GenericFunction.setPlaceholderColor(for: txtFristNm)
        GenericFunction.setPlaceholderColor(for: txtLastNm)
        GenericFunction.setPlaceholderColor(for: txtUserNm)
        GenericFunction.setPlaceholderColor(for: txtEmail)
        GenericFunction.setPlaceholderColor(for: txtPassword)
        GenericFunction.setPlaceholderColor(for: txtConfPassword)
        GenericFunction.setPlaceholderColor(for: txtBirthday)
        GenericFunction.setPlaceholderColor(for: txtGendar)
        GenericFunction.setPlaceholderColor(for: txtCountry)
        
    }
    func passViewControllerObjToViewModel()
    {
        objRegistrationViewModel.vc = self
    }
    func setUpUIRegisterLabel()
    {
        let attributedString = NSMutableAttributedString(string: "Already have an account ?", attributes: lightAttributes)
        attributedString.append(NSAttributedString(string: " ", attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: "Log In", attributes: mediumAttributes))
        lblLogin.attributedText = attributedString
    }
    
    func openGenderActionSheet()
    {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
                self.txtGendar.text = "Female"
                self.strSelectedGender = "female"
            }))
            
            alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
                self.txtGendar.text = "Male"
                self.strSelectedGender = "male"
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
               print("User click Dismiss button")
           }))
           
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
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
        
        if textField == txtFristNm {
            vwFristNm.layer.borderColor = isEditing ? highlightColor : clearColor
            vwFristNm.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0

        }
        else if textField == txtLastNm {
            vwLastNm.layer.borderColor = isEditing ? highlightColor : clearColor
            vwLastNm.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0

        }
        else if textField == txtUserNm {
            vwUserNm.layer.borderColor = isEditing ? highlightColor : clearColor
            vwUserNm.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
        }
        else if textField == txtPassword {
            vwPassword.layer.borderColor = isEditing ? highlightColor : clearColor
            vwPassword.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtConfPassword {
            vwConfPassword.layer.borderColor = isEditing ? highlightColor : clearColor
            vwConfPassword.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
           
        }
        else if textField == txtBirthday
        {
            
            vwBirthday.layer.borderColor = isEditing ? highlightColor : clearColor
            vwBirthday.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            
        }
        else if textField == txtGendar
        {
            vwGendar.layer.borderColor = isEditing ? highlightColor : clearColor
            vwGendar.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwCountry.layer.borderColor = isEditing ? clearColor : highlightColor
            vwCountry.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtCountry
        {
            vwCountry.layer.borderColor = isEditing ? highlightColor : clearColor
            vwCountry.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwFristNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwFristNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwLastNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwLastNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwUserNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwUserNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwBirthday.layer.borderColor = isEditing ? clearColor : highlightColor
            vwBirthday.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwGendar.layer.borderColor = isEditing ? clearColor : highlightColor
            vwGendar.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
    }
}
//MARK: IBAction
extension RegistrationVC
{
    @IBAction func btnPasswordVisibilityTapped(_ sender: Any) {
        txtPassword.isSecureTextEntry.toggle()
           if txtPassword.isSecureTextEntry {
               imgEyePass.image = UIImage(named: "icn_Eye")
           } else {
               imgEyePass.image = UIImage(named: "icn_Eye_Slash")
           }
    }
    @IBAction func btnConfPassVisibilityTapped(_ sender: Any) {
        txtConfPassword.isSecureTextEntry.toggle()
           if txtConfPassword.isSecureTextEntry {
               imgEyeConfPass.image = UIImage(named: "icn_Eye")
           } else {
               imgEyeConfPass.image = UIImage(named: "icn_Eye_Slash")
           }
    }
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRegisterTapped(_ sender: Any) {
        self.validationForRegistration()
    }
    @IBAction func btnCountryTapped(_ sender: Any)
    {
        updateBorder(for: txtCountry, isEditing: true)
        
        let storyboard = UIStoryboard(name: storyboardKey.InnerScreen, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func btnGendarTapped(_ sender: Any)
    {
        updateBorder(for: txtGendar, isEditing: true)
        self.openGenderActionSheet()
    }
    @IBAction func btnBirthdayTapped(_ sender: Any) {
        updateBorder(for: txtBirthday, isEditing: true)
        self.openDatePicker()
    }
    
}
//MARK: UITextFieldDelegate
extension RegistrationVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)
        
    }
}

//MARK: dataPassProtocol Delegate
extension RegistrationVC: dataPassProtocol
{
    func doneButtonTapped(isDonebtnPress: Bool, strDate: String) {
        
    }
    
    func dataPassing(strSelectDate: String, strStatus: String) {
        txtBirthday.text = strSelectDate
    }
}

//MARK: API Call
extension RegistrationVC
{
    func validationForRegistration()
    {
        var isValidate: Bool = false
       // isValidate =  objLoginViewModel.validationForLogin(email: txtEmail.text ?? "", password: txtPassword.text ?? "")
        isValidate =  objRegistrationViewModel.validationForRegistration(userName: txtUserNm.text ?? "", email: txtEmail.text ?? "", password: txtPassword.text ?? "", confirmPassword: txtConfPassword.text ?? "")
        if isValidate {
            self.apiCallRegistration()
        }

    }
    func apiCallRegistration()
    {
        let deviceId: String = AppUserDefaults.object(forKey: "DEVICETOKEN") as? String ?? "2222"

        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objRegistrationViewModel.registrationUser(first_name: txtFristNm.text ?? "", last_name: txtLastNm.text ?? "", username: txtUserNm.text ?? "", email: txtEmail.text ?? "", password: txtPassword.text ?? "", dob: txtBirthday.text ?? "", gender: strSelectedGender, country: txtCountry.text ?? "", device_token: deviceId) { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                
                    if loginResponse.settings?.success == true
                    {
                        UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserLoggedIn")
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.data?.userID ?? 0)", forKey: "USERID")
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(loginResponse.settings?.authorization ?? "")", forKey: "AUTHTOKEN")
                        UserDefaultUtility.saveValueToUserDefaults(value: "SignInUser", forKey: "USERROLE")


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
            KVSpinnerView.dismiss()
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")

        }
    }
    
}
extension RegistrationVC: countryDataPassProtocol
{
    func countryNamePass(strSelectCountry: String) {
        txtCountry.text = strSelectCountry
    }
    
    
}
