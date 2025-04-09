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
//MARK: - UIViewLifeCycle Methods
extension SubsciberVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpScriberSwitch()
        self.setUpHeaderView()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallGetMembershipDetails()
    }
}
//MARK: - General Methods
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
        apiCallGetMembershipDetails()
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
        GenericFunction.registerNibs(for: ["SubsciberNewTBC"], withNibNames: ["SubsciberNewTBC"], tbl: tblSubscriber)
        tblSubscriber.estimatedRowHeight = UITableView.automaticDimension
        tblSubscriber.rowHeight = 200.0
        
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
            strPlanType = "yearly"
            //view.backgroundColor = UIColor.systemGreen
            UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isNotificationOnSubscriber")
        } else {
            print("Switch is OFF")
            planType = "Month"
            print("planType=>\(planType)")
            strPlanType = "monthly"
            //view.backgroundColor = UIColor.systemRed
            UserDefaultUtility.saveValueToUserDefaults(value: "NO", forKey: "isNotificationOnSubscriber")
        }
        self.apiCallGetMembershipDetails()
    }
}
extension SubsciberVC
{
    func sortMembershipPlans() {
            objMembershipPlanResponse?.data?.sort { (plan1, plan2) -> Bool in
                let order = ["Free", "Basic Monthly", "Premium Monthly", "Basic Yearly", "Premium Yearly"]
                guard let index1 = order.firstIndex(of: plan1.name ?? ""),
                      let index2 = order.firstIndex(of: plan2.name ?? "") else {
                    return false
                }
                return index1 < index2
            }
        }
    func apiCallGetMembershipDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objMembershipViewModel.getMembershipPlan(userId: userId, planType: "\(planType)") { result in
                switch result {
                case .success(let response):
                    KVSpinnerView.dismiss()
                    print(response)
                    
                    
                    if response.settings?.success == true
                    {
                        if response.data?.count ?? 0 > 0
                        {
                            self.objMembershipPlanResponse = response
                            
                            self.sortMembershipPlans()
                            
                            self.tblSubscriber.dataSource = self
                            self.tblSubscriber.delegate = self
                            self.tblSubscriber.reloadData()
                            self.tblSubscriber.layoutIfNeeded()

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
extension SubsciberVC: UITableViewDelegate, UITableViewDataSource, SubsciberNewTBCDelegate
{
    
    
    func cell(_ cell: SubsciberNewTBC, idx: Int, planName: String) {
        print("planName-->\(planName)")
        NavigationHelper.pushWithSignaturePassData(storyboardKey.InnerScreen, viewControllerIdentifier: "MembershipLevelVC", from: navigationController!, data: idx, data1: self.objMembershipPlanResponse)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objMembershipPlanResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubsciberNewTBC", for: indexPath) as! SubsciberNewTBC
        cell.delegate = self
        cell.idx = indexPath.row
        cell.selectionStyle = .none
        var cnt: Int = 0
        
        let strFreeContent = "\(objMembershipPlanResponse?.data?[indexPath.row].description ?? "")"

        let arr = strFreeContent.components(separatedBy: "|")

        cnt = arr.count
        cell.configureViews(for: cnt, withResponse: objMembershipPlanResponse, andIndex: indexPath.row, planType: planType, arrFreeContent: arr)

        
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
