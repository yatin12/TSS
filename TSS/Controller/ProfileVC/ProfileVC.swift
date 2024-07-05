//
//  ProfileVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class ProfileVC: UIViewController {
    var imagePickerManager: ImagePickerManager?
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
        self.setUpHeaderView()
        self.setUpPlaceholderColor()
    }
}
//MARK: General Methods
extension ProfileVC
{
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
            
            if isEditing {
                txtEmail.text = ""
                txtPhone.text = ""
                txtPassword.text = ""
                txtConfPassword.text = ""
            }
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
            
            if isEditing {
                txtDisplayNm.text = ""
                txtPhone.text = ""
                txtPassword.text = ""
                txtConfPassword.text = ""
            }
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
            
            if isEditing {
                txtDisplayNm.text = ""
                txtEmail.text = ""
                txtPassword.text = ""
                txtConfPassword.text = ""
            }
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
            
            if isEditing {
                txtDisplayNm.text = ""
                txtEmail.text = ""
                txtPhone.text = ""
                txtConfPassword.text = ""
            }
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
            
            if isEditing {
                txtDisplayNm.text = ""
                txtEmail.text = ""
                txtPhone.text = ""
                txtPassword.text = ""
            }
        }
    }
}
//MARK: IBAction
extension ProfileVC
{
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
