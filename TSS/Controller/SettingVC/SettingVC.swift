//
//  SettingVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class SettingVC: UIViewController {
    
   
    
    @IBOutlet weak var tblSetting: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    let arr = ["Notifications", "Subscriber", "Account Setting", "App Preferences", "Favourites", "Upcoming Events", "Help & Feedback", "About Us", "Privacy Policy", "Term & Condition", "Contact Us"]
}
//MARK: UIViewLife Cycle Methods
extension SettingVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.registerNib()
        
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
    }
    
}
//MARK: IBAction
extension SettingVC
{
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

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
            break
            
        case 2:
            //Account Setting
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "ProfileVC", from: navigationController!, animated: true)
            break
        case 3:
            //App Preferences
            break
        case 4:
            //Favourites
            break
        case 5:
            //Upcoming events
            break
        case 6:
           // Help & Feedback
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "FeedbackVC", from: navigationController!, animated: true)
            break
        case 7:
           // About Us
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "AboutUsVC", from: navigationController!, animated: true)
            break
        case 8:
           // Privacy Policy
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "PrivacyPolicyVC", from: navigationController!, animated: true)
            break
        case 9:
           // Term & Condition
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TermsConditionVC", from: navigationController!, animated: true)
            break
        case 10:
           // Contact Us
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "ContactUSVC", from: navigationController!, animated: true)
            break
        
        default:
            break
        }
    }
}
