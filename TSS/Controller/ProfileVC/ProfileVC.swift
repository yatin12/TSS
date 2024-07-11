//
//  ProfileVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class ProfileVC: UIViewController {
    //  - Variables - 
    var userId: String = ""
   
    @IBOutlet weak var imgEyeConfPass: UIImageView!
    @IBOutlet weak var imgEyePassword: UIImageView!
    private let objGetProfileViewModel = GetProfileViewModel()
    private let objUpdateProfileViewModel = updateProfileViewModel()
    var imagePickerManager: ImagePickerManager?
    
    //  - Outlets - 
    @IBOutlet weak var lblHeaderNm: UILabel!
    @IBOutlet weak var txtConfPassword: UITextField!
    @IBOutlet weak var vwConfPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDisplayNm: UITextField!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwDisplayNm: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLifeCycle Methods
extension ProfileVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpHeaderView()
        self.setUpPlaceholderColor()
        self.apiCallGetProfile()
    }
}
//MARK: General Methods
extension ProfileVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setUpPlaceholderColor()
    {
        GenericFunction.setPlaceholderColor(for: txtDisplayNm)
        GenericFunction.setPlaceholderColor(for: txtEmail)
        GenericFunction.setPlaceholderColor(for: txtPassword)
        GenericFunction.setPlaceholderColor(for: txtConfPassword)
        GenericFunction.setPlaceholderColor(for: txtPhone)
        
    }
    func openImagePicker()
    {
        imagePickerManager = ImagePickerManager(presentingViewController: self)
        imagePickerManager?.delegate = self
        imagePickerManager?.showImagePickerActionSheet()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    private func updateBorder(for textField: UITextField, isEditing: Bool) {

        
        if textField == txtDisplayNm {
            vwDisplayNm.layer.borderColor = isEditing ? highlightColor : clearColor
            vwDisplayNm.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPhone.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPhone.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtEmail
        {
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwDisplayNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwDisplayNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPhone.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPhone.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtPhone
        {
            vwPhone.layer.borderColor = isEditing ? highlightColor : clearColor
            vwPhone.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwDisplayNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwDisplayNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
        else if textField == txtPassword
        {
            vwPassword.layer.borderColor = isEditing ? highlightColor : clearColor
            vwPassword.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwDisplayNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwDisplayNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPhone.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPhone.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwConfPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwConfPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
           
        }
        else if textField == txtConfPassword
        {
            vwConfPassword.layer.borderColor = isEditing ? highlightColor : clearColor
            vwConfPassword.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwDisplayNm.layer.borderColor = isEditing ? clearColor : highlightColor
            vwDisplayNm.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPhone.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPhone.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwPassword.layer.borderColor = isEditing ? clearColor : highlightColor
            vwPassword.layer.borderWidth = isEditing ? 0.0 : 1.0
            
        }
    }
}
//MARK: IBAction
extension ProfileVC
{
    @IBAction func btnPassVisibilityTapped(_ sender: Any) {
        txtPassword.isSecureTextEntry.toggle()
           if txtPassword.isSecureTextEntry {
               imgEyePassword.image = UIImage(named: "icn_Eye")
           } else {
               imgEyePassword.image = UIImage(named: "icn_Eye_Slash")
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
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
    }
    @IBAction func btnUpdateProfilePicTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.openImagePicker()
    }
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.apiCallUpdateProfile()
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
    }
}
//MARK: UITextFieldDelegate
extension ProfileVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)

    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)

    }
}
//MARK: ImagePickerDelegate
extension ProfileVC: ImagePickerDelegate
{
    func didSelectImage(_ image: UIImage) {
        imgProfilePic.image = image
    }
}
//MARK: API Call
extension ProfileVC
{
    func setUpUIAfterGettingResponse(response: GetProfileResponse?)
    {
        txtEmail.text = "\(response?.data?.email ?? "")"
        txtPhone.text = "\(response?.data?.phone ?? "")"
        txtPassword.text = "\(response?.data?.password ?? "")"
        txtConfPassword.text = "\(response?.data?.password ?? "")"
        txtDisplayNm.text = "\(response?.data?.userName ?? "")"
        
        let strBlogUrl = "\(response?.data?.imageURL ?? "")"
        imgProfilePic.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)

    }
    func apiCallGetProfile()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objGetProfileViewModel.getProfile(userId: userId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        self.setUpUIAfterGettingResponse(response: response)

                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
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
    func apiCallUpdateProfile()
    {
        if Reachability.isConnectedToNetwork()
        {
            objUpdateProfileViewModel.updateProfile(profileImgData: imgProfilePic.image?.jpeg(.lowest), userId: userId, userName: txtDisplayNm.text ?? "", email: txtEmail.text ?? "", phone: txtPhone.text ?? "", password: txtPassword.text ?? "") { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        AlertUtility.presentAlert(in: self, title: "", message: "\(response.settings?.message ?? "")", options: "Ok") { option in
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
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
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
