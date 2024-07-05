//
//  ContactUSVC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit

class ContactUSVC: UIViewController {
    let placeholderText = "Enter Message"
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    @IBOutlet weak var txtvwMsg: UITextView!
    @IBOutlet weak var vwMsg: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var vwName: UIView!
}
//MARK: UIViewLife Cycle Methods
extension ContactUSVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPlaceholderColor()
        self.setUpHeaderView()
        self.setupTextView()
    }
}
//MARK: General Methods
extension ContactUSVC
{
    func setupTextView()
    {
        txtvwMsg.text = placeholderText
        txtvwMsg.textColor = UIColor.lightGray
    }
    func setUpPlaceholderColor()
    {
        GenericFunction.setPlaceholderColor(for: txtName)
        GenericFunction.setPlaceholderColor(for: txtEmail)
    }
    
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    private func updateBorder(for textField: UITextField, isEditing: Bool) {
        
        
        if textField == txtName {
            vwName.layer.borderColor = isEditing ? highlightColor : clearColor
            vwName.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwMsg.layer.borderColor = isEditing ? clearColor : highlightColor
            vwMsg.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            if isEditing {
                txtEmail.text = ""
                txtvwMsg.text = placeholderText
            }
        } else if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwName.layer.borderColor = isEditing ? clearColor : highlightColor
            vwName.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwMsg.layer.borderColor = isEditing ? clearColor : highlightColor
            vwMsg.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            if isEditing {
                txtName.text = ""
                txtvwMsg.text = placeholderText
            }
        }
    }
    private func updateBorderTextView(for textview: UITextView, isEditing: Bool) {
        
        
        if textview == txtvwMsg {
            vwMsg.layer.borderColor = isEditing ? highlightColor : clearColor
            vwMsg.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwEmail.layer.borderColor = isEditing ? clearColor : highlightColor
            vwEmail.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwName.layer.borderColor = isEditing ? clearColor : highlightColor
            vwName.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            if isEditing {
                txtEmail.text = ""
                txtName.text = ""
            }
        }
    }
}
//MARK: IBAction
extension ContactUSVC
{
    @IBAction func btnTikTokTapped(_ sender: Any) {
    }
    @IBAction func btnInstaTapped(_ sender: Any) {
    }
    @IBAction func btnFBTapped(_ sender: Any) {
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnsearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSubmitTapped(_ sender: Any) {
    }
}
//MARK: UITextFieldDelegate
extension ContactUSVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)
        
    }
}
//MARK: UITextViewDelegate
extension ContactUSVC: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //  UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserModified")
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = AppColors.ThemeFontColor
            textView.text = text
        }
        
        
        else {
            return true
        }
        
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateBorderTextView(for: textView, isEditing: true)
        
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = AppColors.ThemeFontColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateBorderTextView(for: textView, isEditing: false)
        
        if textView.text.isEmpty && textView.text != placeholderText {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
