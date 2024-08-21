//
//  SettingVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class SettingVC: UIViewController {
    //  - Variables - 
    let arr = ["Notifications", "Subscriber", "Account Setting", "App Preferences", "Favourites", "Upcoming Events", "Help & Feedback", "About Us", "Privacy Policy", "Term & Condition", "Contact Us", "Logout", "Delete Account"]
    var userRole: String = ""
    var userId: String = ""
    var isSubscribedUser: String = ""
    //  - Outlets - 
    let objDeleteAccountViewModel = deleteAccountViewModel()
    let objLogoutViewModel = LogoutViewModel()

    @IBOutlet weak var tblSetting: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension SettingVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.registerNib()
        self.getUserId()
        
    }
}
//MARK: General Methods
extension SettingVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["SettingTBC"], withNibNames: ["SettingTBC"], tbl: tblSetting)
        tblSetting.reloadData()
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""

    }
    
    
}
//MARK: IBAction
extension SettingVC
{
    @IBAction func btnSearchTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Switch is ON")
            //view.backgroundColor = UIColor.systemGreen
            UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isNotificationOn")
        } else {
            print("Switch is OFF")
            //view.backgroundColor = UIColor.systemRed
            UserDefaultUtility.saveValueToUserDefaults(value: "NO", forKey: "isNotificationOn")
        }
    }
    
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension SettingVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTBC", for: indexPath) as! SettingTBC
        cell.selectionStyle = .none
        cell.lblCategory.text = "\(arr[indexPath.row])"
        
        cell.swtNotificationOutlt.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        let notificationStatus : String = AppUserDefaults.object(forKey: "isNotificationOn") as? String ?? "NO"
        
        if notificationStatus == "YES" {
            cell.swtNotificationOutlt.setOn(true, animated: false)
            
        }
        else
        {
            cell.swtNotificationOutlt.setOn(false, animated: false)
        }
        
        
        if cell.lblCategory.text == "Notifications"
        {
            cell.imgNext.isHidden = true
            cell.swtNotificationOutlt.isHidden = false
        }
        else if cell.lblCategory.text == "Notifications" || cell.lblCategory.text == "Subscriber" || cell.lblCategory.text == "Account Setting" || cell.lblCategory.text == "App Preferences"
        {
            cell.imgNext.isHidden = false
            cell.swtNotificationOutlt.isHidden = true
        }
        else
        {
            cell.imgNext.isHidden = true
            cell.swtNotificationOutlt.isHidden = true
        }
        
        let underscored = cell.lblCategory.text?.replacingOccurrences(of: " ", with: "_")
        cell.imgCategory.image = UIImage(named: "\("icn_" + (underscored ?? ""))")
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx: Int = indexPath.row
        switch idx
        {
        case 1:
            //Subscriber
            if userRole == USERROLE.SignInUser
            {
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            break
            
        case 2:
            if userRole == USERROLE.SignInUser
            {
                //Account Setting
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "ProfileVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            break
        case 3:
            //App Preferences
            if userRole == USERROLE.SignInUser
            {
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "LiveShowVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            break
        case 4:
            //Favourites
            if userRole == USERROLE.SignInUser
            {
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "FavouriteListVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            
            break
        case 5:
            //Upcoming events
            if userRole == USERROLE.SignInUser
            {
                isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
                if isSubscribedUser == "\(SubscibeUserType.premium)"
                {
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "UpComingEventVC", from: navigationController!, animated: true)

                }
                else
                {
                    AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.subscribeForTabMsg)")

                }
                
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            
            break
        case 6:
            // Help & Feedback
            if userRole == USERROLE.SignInUser
            {
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "FeedbackVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            break
        case 7:
            // About Us
            
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "AboutUsVC", from: navigationController!, animated: true)
            break
        case 8:
            // Privacy Policy
            isFromPrivacyViewSetting = true
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "PrivacyPolicyVC", from: navigationController!, animated: true)
            break
        case 9:
            // Term & Condition
            isFromTermsViewSetting = true
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TermsConditionVC", from: navigationController!, animated: true)
            break
        case 10:
            // Contact Us
            if userRole == USERROLE.SignInUser
            {
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "ContactUSVC", from: navigationController!, animated: true)
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            break
            
        case 11:
            // Logout
            
            
            AlertUtility.presentAlert(in: self, title: "", message: "\(AlertMessages.LogoutMsg)", options: "Yes", "No") { option in
                switch(option) {
                case 0:
                    self.apiCallLogout()
                    /*
                    self.clearParamInLocal()
                    NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "SplashScreenVC", from: self.navigationController!, animated: false)
                    */
                    break
                    
                case 1:
                    break
                default:
                    break
                }
            }
            
        case 12:
            // Delete Account
            
            
            AlertUtility.presentAlert(in: self, title: "", message: "\(AlertMessages.deleteAccountMsg)", options: "Yes", "No") { option in
                switch(option) {
                case 0:
                    self.apiCallDeleteAccount()
                    
                    break
                    
                case 1:
                    break
                default:
                    break
                }
            }
            
        default:
            break
        }
    }
    func clearParamInLocal()
    {
        UserDefaults.standard.set("", forKey: "AUTHTOKEN")
        UserDefaults.standard.set("NO", forKey: "isUserLoggedIn")
        UserDefaults.standard.set("", forKey: "DEVICETOKEN")
        UserDefaults.standard.set("", forKey: "FCMTOKEN")
        UserDefaults.standard.synchronize()
    }
}
extension SettingVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func apiCallLogout()
    {
        KVSpinnerView.show()
        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
            objLogoutViewModel.logoutAPi(userId: userId) { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    
                    if loginResponse.settings?.success == true
                    {
                        self.clearParamInLocal()
                        NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "SplashScreenVC", from: self.navigationController!, animated: false)
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
    func apiCallDeleteAccount()
    {
        KVSpinnerView.show()
        self.view.endEditing(true)
        if Reachability.isConnectedToNetwork()
        {
          
            objDeleteAccountViewModel.deleteAccountApi(userId: userId) { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    
                    if loginResponse.settings?.success == true
                    {
                        self.clearParamInLocal()
                        NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "SplashScreenVC", from: self.navigationController!, animated: false)
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
