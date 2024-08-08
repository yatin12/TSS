//
//  FeedbackVC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit
import KVSpinnerView

class FeedbackVC: UIViewController {
    //  - Variables - 
    let placeholderText = "Enter Message"
    var userId: String = ""
    private let objSendContactViewModel = sendContactViewModel()

    //  - Outlets - 
    @IBOutlet weak var txtvwMsg: UITextView!
    @IBOutlet weak var vwMsg: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var vwName: UIView!
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension FeedbackVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.passViewControllerObjToViewModel()
        self.setUpPlaceholderColor()
        self.setUpHeaderView()
        self.setupTextView()
    }
}
//MARK: General Methods
extension FeedbackVC
{
    func passViewControllerObjToViewModel()
    {
        objSendContactViewModel.vc_Feedback = self
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
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
            
            
        } else if textField == txtEmail {
            vwEmail.layer.borderColor = isEditing ? highlightColor : clearColor
            vwEmail.layer.borderWidth = isEditing ? 1.0 : 0.0
            
            vwName.layer.borderColor = isEditing ? clearColor : highlightColor
            vwName.layer.borderWidth = isEditing ? 0.0 : 1.0
            
            vwMsg.layer.borderColor = isEditing ? clearColor : highlightColor
            vwMsg.layer.borderWidth = isEditing ? 0.0 : 1.0
            
          
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
          
        }
    }
}
//MARK: IBAction
extension FeedbackVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.validationForFeedback()
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
    }
}
//MARK: UITextFieldDelegate
extension FeedbackVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorder(for: textField, isEditing: false)
        
    }
}
//MARK: UITextViewDelegate
extension FeedbackVC: UITextViewDelegate {
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
extension FeedbackVC
{
    func validationForFeedback()
    {
        var isValidate: Bool = false
        isValidate =  objSendContactViewModel.validationForFeedback(email: txtEmail.text ?? "", your_name: txtName.text ?? "", message: txtvwMsg.text ?? "")
        if isValidate {
            self.apiCallSendContactList()
        }

    }
    func apiCallSendContactList()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objSendContactViewModel.sendContactDetails(user_id: userId, your_name: txtName.text ?? "", email: txtEmail.text ?? "", message: txtvwMsg.text ?? "", type: "help") { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                   
                    AlertUtility.presentAlert(in: self, title: "", message: "\(response.settings?.message ?? "")", options: "Ok") { option in
                        switch(option) {
                        case 0:
                            self.navigationController?.popViewController(animated: true)
                            break
                       
                        default:
                            break
                        }
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
