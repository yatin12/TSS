//
//  SubsciberVC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit
import KVSpinnerView

class SubsciberVC: UIViewController {
    //  - Variables - 
    var planType: String = "Month"
    var objMembershipPlanResponse: membershipPlanResponse?
    var expandedCells = Set<IndexPath>()
    
    @IBOutlet weak var lblNoData: UILabel!
    
    
    
    @IBOutlet weak var swtSubscriber: UISwitch!
    @IBOutlet weak var tblSubscriber: UITableView!
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    private let objMembershipViewModel = membershipViewModel()
    var userId: String = ""
    //  - Outlets - 
}
//MARK: UIViewLifeCycle Methods
extension SubsciberVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpScriberSwitch()
        self.setUpHeaderView()
        self.apiCallGetMembershipDetails()
        
    }
}
//MARK: General Methods
extension SubsciberVC
{
    func setUpNoData()
    {
        lblNoData.isHidden = false
        tblSubscriber.isHidden = true
    }
    func setUpScriberSwitch()
    {
        swtSubscriber.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        let notificationStatus : String = AppUserDefaults.object(forKey: "isNotificationOnSubscriber") as? String ?? "NO"
        
        if notificationStatus == "YES" {
            swtSubscriber.setOn(true, animated: false)
            planType = "Year"
            
        }
        else
        {
            swtSubscriber.setOn(false, animated: false)
            planType = "Month"
        }
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["SubsciberTBC"], withNibNames: ["SubsciberTBC"], tbl: tblSubscriber)
        tblSubscriber.estimatedRowHeight = UITableView.automaticDimension
        tblSubscriber.rowHeight = 275.0
        
    }
}
//MARK: IBAction
extension SubsciberVC
{
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func objSwtSubscriberValueChange(_ sender: UISwitch) {
        if sender.isOn {
            print("Switch is ON")
            planType = "Year"
            print("planType=>\(planType)")
            //view.backgroundColor = UIColor.systemGreen
            UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isNotificationOnSubscriber")
        } else {
            print("Switch is OFF")
            planType = "Month"
            print("planType=>\(planType)")
            //view.backgroundColor = UIColor.systemRed
            UserDefaultUtility.saveValueToUserDefaults(value: "NO", forKey: "isNotificationOnSubscriber")
        }
        self.apiCallGetMembershipDetails()
    }
}
extension SubsciberVC
{
    func apiCallGetMembershipDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objMembershipViewModel.getMembershipPlan(userId: userId, planType: "\(subscriptionPlanTime.Year)") { result in
                switch result {
                case .success(let response):
                    KVSpinnerView.dismiss()
                    print(response)
                    
                    
                    if response.settings?.success == true
                    {
                        if response.data?.count ?? 0 > 0
                        {
                            self.objMembershipPlanResponse = response
                            self.tblSubscriber.dataSource = self
                            self.tblSubscriber.delegate = self
                            self.tblSubscriber.reloadData()
                            
                            self.lblNoData.isHidden = true
                            self.tblSubscriber.isHidden = false
                        }
                        else
                        {
                            self.setUpNoData()
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
//MARK: UITableViewDelegate, UITableViewDataSource
extension SubsciberVC: UITableViewDelegate, UITableViewDataSource, SubsciberTBCDelegate
{
    func cell(_ cell: SubsciberTBC, idx: Int) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "MembershipLevelVC", from: navigationController!, animated: true)

    }
    
    func didTapLearnMore(for cell: SubsciberTBC) {
        guard let indexPath = tblSubscriber.indexPath(for: cell) else { return }
        expandCell(at: indexPath)
    }
    func expandCell(at indexPath: IndexPath) {
        if expandedCells.contains(indexPath) {
            expandedCells.remove(indexPath)
        } else {
            expandedCells.insert(indexPath)
        }
        tblSubscriber.reloadRows(at: [indexPath], with: .automatic)
        
//        tblSubscriber.performBatchUpdates({
//               self.tblSubscriber.reloadRows(at: [indexPath], with: .automatic)
//           }, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objMembershipPlanResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubsciberTBC", for: indexPath) as! SubsciberTBC
        cell.delegate = self
        cell.idx = indexPath.row
        cell.selectionStyle = .none
        var cnt: Int = 0
        if indexPath.row == 0 {
            let strFreeContent = "Free Videos, Empowerment, News"
            let arr = strFreeContent.components(separatedBy: ",")
            cnt = arr.count
            
        }
        else  if indexPath.row == 1 {
            let strFreeContent = "Free Videos, Empowerment, Evideos, Tops and News"
            let arr = strFreeContent.components(separatedBy: ",")
            cnt = arr.count
            
        }
        else  if indexPath.row == 2 {
            let strFreeContent = "Free Videos"
            let arr = strFreeContent.components(separatedBy: ",")
            cnt = arr.count
            
        }
        
        cell.configureViews(for: cnt, withResponse: objMembershipPlanResponse, andIndex: indexPath.row, planType: planType)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let baseHeight: CGFloat = 275.0 // Minimum height for collapsed cells
            let expandedExtraHeight: CGFloat = 150.0 // Additional height when expanded
            
            if expandedCells.contains(indexPath) {
                return max(UITableView.automaticDimension, baseHeight + expandedExtraHeight)
            } else {
                return UITableView.automaticDimension
            }
        
//       //  return UITableView.automaticDimension
//        return expandedCells.contains(indexPath) ? 500 : 275.0 // Adjust these values as needed
//      //  return expandedCells.contains(indexPath) ? (UITableView.automaticDimension + 100) : 375.0 // Adjust these values as needed

        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
