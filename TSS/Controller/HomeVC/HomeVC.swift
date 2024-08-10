//
//  HomeVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class HomeVC: UIViewController {
    //  - Variables - 
    
    var objHomeResposne: HomeResposne?
    let objHomeViewModel = HomeViewModel()
    var arrSection: [String] = []
    var userId: String = ""
    var userRole: String = ""
    var isSubscribedUser: String = ""

    //  - Outlets - 
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension HomeVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpHeaderView()
        self.setNotificationObserverMethod()
        self.setSectionAccordingUser()
        self.registerNib()
        self.apiCallgetHomeData()
        
    }
}
//MARK: General Methods
extension HomeVC
{
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallHomeTab(notification:)), name: Notification.Name("APIcallforHome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.season1TBS(notification:)), name: Notification.Name("btnWatchNowTapped"), object: nil)
        
    }
    @objc func apicallHomeTab(notification: Notification)
    {
        self.apiCallgetHomeData()
    }
    @objc func season1TBS(notification: Notification)
    {
        isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
        if isSubscribedUser == "\(SubscibeUserType.premium)"
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "Season1TBSVC", from: navigationController!, animated: true)

        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.subscribeForTabMsg)")

        }
        
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
    }
    func setSectionAccordingUser()
    {
        if userRole == USERROLE.SignInUser
        {
            arrSection = ["","Tops News", "Season 1", "Season 1 BTS (Behind the Scenes)", "E.Videos", "Recommended Episodes","Meet The Sisters"]
        }
        else
        {
            arrSection = ["","Tops News", "Recommended Episodes","Meet The Sisters"]
        }
    }
    func registerNib()
    {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
        
        GenericFunction.registerNibs(for: ["HomeTBC"], withNibNames: ["HomeTBC"], tbl: tblHome)
        //        tblHome.delegate = self
        //        tblHome.dataSource = self
        //        tblHome.reloadData()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    //    func setUpUIAfterGettingResponse(response: HomeResposne?)
    //    {
    //
    //    }
}
//MARK: IBAction
extension HomeVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
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
}
//MARK: UITableViewDataSource & UITableViewDelegate
extension HomeVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeHeaderView()
        
        headerView.lblCategoryName.text = "\(arrSection[section])"
        
        if headerView.lblCategoryName.text == "Season 1 BTS (Behind the Scenes)"
        {
            headerView.lblViewAll.isHidden = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
            headerView.addGestureRecognizer(tapGestureRecognizer)
            headerView.tag = section // Set the tag to identify the section in the tap handler
        }
        else if headerView.lblCategoryName.text == "Meet The Sisters"
        {
            headerView.lblViewAll.isHidden = true
        }
        else
        {
            headerView.lblViewAll.isHidden = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
            headerView.addGestureRecognizer(tapGestureRecognizer)
            headerView.tag = section // Set the tag to identify the section in the tap handler
        }
        
        
        
        
        return headerView
    }
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        if userRole == USERROLE.SignInUser
        {
            if let section = sender.view?.tag {
                print("Header tapped in section \(section)")
                switch section {
                case 1:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsVC", from: navigationController!, animated: true)
                    break
                case 2:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 3:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 4:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                case 5:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                default:
                    break
                }
            }
        }
        else
        {
            if let section = sender.view?.tag {
                print("Header tapped in section \(section)")
                switch section {
                case 1:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsVC", from: navigationController!, animated: true)
                    break
                case 2:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                case 3:
                    
                    break
                default:
                    break
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: Int = 50
        if section == 0
        {
            sectionHeight = 0
        }
        else
        {
            sectionHeight = 50
        }
        return CGFloat(sectionHeight) // Set the desired height for section headers
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTBC", for: indexPath) as! HomeTBC
        cell.selectionStyle = .none
        
        cell.imgSectionZero.isHidden = true
        cell.objCollectionHome.isHidden = true
        cell.objCollectionMeetSister.isHidden = true
        cell.objCollection1TBS.isHidden = true
        
        if userRole == USERROLE.SignInUser
        {
            if indexPath.section == 0 {
                cell.imgSectionZero.isHidden = false
            }
            else if indexPath.section == 3 {
                cell.objCollection1TBS.isHidden = false
            }
            else if indexPath.section == arrSection.count - 1 {
                cell.objCollectionMeetSister.isHidden = false
            }
            else {
                cell.objCollectionHome.isHidden = false
            }
        }
        else
        {
           //            arrSection = ["","Tops News", "Recommended Episodes","Meet The Sisters"]
            
            if indexPath.section == 0 {
                cell.imgSectionZero.isHidden = false
            }
            else if indexPath.section == arrSection.count - 1 {
                cell.objCollectionMeetSister.isHidden = false
            }
            else {
                cell.objCollectionHome.isHidden = false
            }
        }
        
        cell.configure(withResponse: objHomeResposne, withIndex: indexPath.row, strSectionNm: "\(arrSection[indexPath.section])")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Int = 225
        if userRole == USERROLE.SignInUser
        {
            if indexPath.section == arrSection.count - 1
            {
                rowHeight = 250
            }
            else if indexPath.section == 3
            {
                rowHeight = 80
            }
            else
            {
                rowHeight = 225
            }
        }
        else
        {
            if indexPath.section == arrSection.count - 1
            {
                rowHeight = 250
            }
            else
            {
                rowHeight = 225
            }
        }
        return CGFloat(rowHeight)
    }
}
extension HomeVC
{
    func apiCallgetHomeData()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objHomeViewModel.getHomeListData(userId: userId) { result in
                switch result {
                case .success(let response):
                    
                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        //self.setUpUIAfterGettingResponse(response: response)
                        print(response)
                        self.objHomeResposne = response
                        self.tblHome.delegate = self
                        self.tblHome.dataSource = self
                        self.tblHome.reloadData()
                    }
                    else
                    {
                        KVSpinnerView.dismiss()
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
