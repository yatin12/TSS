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
    }
}
//MARK: General Methods
extension SubsciberVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
}
//MARK: IBAction
extension SubsciberVC
{
    

}
extension SubsciberVC
{
    func apiCallGetBlogDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objMembershipViewModel.getMembershipPlan(userId: userId, planType: "\(subscriptionPlanTime.Year)") { result in
                switch result {
                case .success(let response):
                    KVSpinnerView.dismiss()
                    print(response)
                   
                    /*
                    if response.settings?.success == true
                    {
                        self.objBlogDetailsResponse = response
                        self.tblNewsDetails.dataSource = self
                        self.tblNewsDetails.delegate = self
                        self.tblNewsDetails.reloadData()
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")
                    }
                    */
                    
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
