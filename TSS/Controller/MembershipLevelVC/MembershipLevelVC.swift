//
//  MembershipLevelVC.swift
//  TSS
//
//  Created by apple on 23/07/24.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import KVSpinnerView

class MembershipLevelVC: UIViewController {
    var userId: String = ""
    var strProductId: String = ""
    var idx: Int?
    var objMembershipPlanResponse: membershipPlanResponse?
    let arrType: [String] = ["Platinum"]
    let arrTimeType: [String] = ["month"]
    
    var strPlanPrice: String = ""
    
    var productId: String = ""
    var transactionIdentifier: String = ""
    var transactionDate: String = ""
    var transactionState: String = ""
    var productPrice: String = ""
    var productPriceLocal: String = ""
    var productPurchaseCurrencyCode: String = ""
    
    
    /*
     var productId: String = "com.thesistersshowllc.basicMonthly"
     var transactionIdentifier: String = "2000000742455344"
     var transactionDate: String = "2024-10-14 16:26:16 +0000"
     var transactionState: String = "purchased"
     var productPrice: String = "299"
     var productPriceLocal: String = "en_IN@currency=INR (fixed en_IN@currency=INR)"
     var productPurchaseCurrencyCode: String = "INR"
     */
    
    let objSubscriptionPurchaseViewModel = subscriptionPurchaseViewModel()
    
    
    
    @IBOutlet weak var tblMembership: UITableView!
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
extension MembershipLevelVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpHeaderView()
        self.registerNib()
        
    }
}
extension MembershipLevelVC
{
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
        GenericFunction.registerNibs(for: ["MembershipLevelNewTBC"], withNibNames: ["MembershipLevelNewTBC"], tbl: tblMembership)
        tblMembership.estimatedRowHeight = UITableView.automaticDimension
        tblMembership.rowHeight = 381.0
        tblMembership.delegate = self
        tblMembership.dataSource = self
        
    }
}
extension MembershipLevelVC
{
    @IBAction func btnRestoreTapped(_ sender: Any) {
        KVSpinnerView.show()
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    @IBAction func btnSubmitTapped(_ sender: Any) {
        // self.apiCallPostCancelSubscriptionInfo()
        // self.apiCallPostSubscriptionInfo()
        self.purchase("\(strProductId)", atomically: true)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension MembershipLevelVC: UITableViewDelegate, UITableViewDataSource, MembershipLevelNewTBCDelegate
{
    func cell(_ cell: MembershipLevelNewTBC, idx: Int) {
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipLevelNewTBC", for: indexPath) as! MembershipLevelNewTBC
        
        cell.delegate = self
        cell.idx = idx ?? 0
        cell.strPlanNm = "\(objMembershipPlanResponse?.data?[idx ?? 0].name ?? "")"
        //        cell.strPrice = "\(objMembershipPlanResponse?.data?[idx ?? 0].billingAmount ?? "")"
        
        cell.strPrice = strPlanPrice
        
        strProductId = "\(objMembershipPlanResponse?.data?[idx ?? 0].productId ?? "")"
        
        getPurchaseInfo(inappPurchaseId: strProductId) { (price, currencySymbol) in
            if let price = price, let currencySymbol = currencySymbol {
                print("The price is \(currencySymbol)\(price)")
                // Use the price and currency symbol here
//                let PPrice = 2.989999999999
                let roundedPrice = String(format: "%.2f", price)
                print("The rounded Price is \(currencySymbol)\(roundedPrice)")
                
                self.strPlanPrice = "\(currencySymbol)\(roundedPrice)"
                
                // Extract currency code from priceLocale
                self.productPurchaseCurrencyCode = currencySymbol
                print("Currency Code: \(self.productPurchaseCurrencyCode)")
                
                self.tblMembership.delegate = self
                self.tblMembership.dataSource = self
                self.tblMembership.reloadData()
                
            } else {
                print("Failed to retrieve price information")
                
                self.tblMembership.delegate = self
                self.tblMembership.dataSource = self
                self.tblMembership.reloadData()
            }
        }
        
        //        print(objMembershipPlanResponse?.data?[idx ?? 0].billingAmount ?? "")
        //        print(objMembershipPlanResponse?.data?[idx ?? 0].name ?? "")
        
        cell.selectionStyle = .none
        var cnt: Int = 0
        
        let strFreeContent = "\(objMembershipPlanResponse?.data?[idx ?? 0].description ?? "")"
        
        let arr = strFreeContent.components(separatedBy: "|")
        
        cnt = arr.count
        cell.configureViews(for: cnt, withResponse: objMembershipPlanResponse, andIndex: indexPath.row, arrFreeContent: arr)
        
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
//MARK: - IN APP Purchase
extension MembershipLevelVC
{
    func getPurchaseInfo(inappPurchaseId: String, completion: @escaping (Double?, String?) -> Void) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([inappPurchaseId]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let price = product.price.doubleValue
                //                let currencySymbol = product.priceLocale.currencyCode ?? "Unknown Currency"
                let currencySymbol = product.priceLocale.currencySymbol ?? "Unknown Currency"
                
                
                print("product.localizedDescription-->\(product.localizedDescription)")
                print("price-->\(price)")
                print("Currency Symbol: \(currencySymbol)")
                //  let currencyCode = product.priceLocale.currencyCode ?? "Unknown Currency"
                
                
                
                // Get country name based on the currency code
                
                completion(price, currencySymbol)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func purchase(_ inappPurchaseId: String, atomically: Bool) {
        KVSpinnerView.show()
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(inappPurchaseId, atomically: atomically) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                
                
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            
            
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
            
        }
    }
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        KVSpinnerView.dismiss()
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            purchaseUtility.setProductPurchased(false)
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            isProductPurchased = false
            
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            purchaseUtility.setProductPurchased(true)
            UserDefaultUtility.saveValueToUserDefaults(value: strPlanType, forKey: "whichPlanPurchased")
            
            isProductPurchased = true
            
            self.productId = "\(results.restoredPurchases[0].productId)"
            self.transactionIdentifier = "\(results.restoredPurchases[0].transaction.transactionIdentifier ?? "")"
            //            self.transactionDate = "\(results.restoredPurchases[0].transaction.transactionDate ?? Date())"
            self.transactionDate = "\(results.restoredPurchases[0].originalPurchaseDate)"
            
            self.transactionState = "\(results.restoredPurchases[0].transaction.transactionState)"
            
            self.apiCallPostSubscriptionInfo()
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            
            purchaseUtility.setProductPurchased(false)
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            isProductPurchased = false
            
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        // KVSpinnerView.dismiss()
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            self.productId = "\(purchase.productId)"
            self.transactionIdentifier = "\(purchase.transaction.transactionIdentifier ?? "")"
            self.transactionDate = "\(purchase.transaction.transactionDate ?? Date())"
            self.transactionState = "\(purchase.transaction.transactionState)"
            self.productPrice = "\(purchase.product.price)"
            self.productPriceLocal = "\(purchase.product.priceLocale)"
            
            purchaseUtility.setProductPurchased(true)
            isProductPurchased = true
            UserDefaultUtility.saveValueToUserDefaults(value: strPlanType, forKey: "whichPlanPurchased")
            
            self.apiCallPostSubscriptionInfo()
            
            return nil
        case .error(let error):
            
            print("Purchase Failed: \(error)")
            purchaseUtility.setProductPurchased(false)
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            isProductPurchased = false
            KVSpinnerView.dismiss()
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        case .deferred(purchase: let purchase):
            purchaseUtility.setProductPurchased(false)
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            isProductPurchased = false
            
            return alertWithTitle("deferred", message: "deferred")
        }
    }
}
extension MembershipLevelVC
{
    func apiCallPostCancelSubscriptionInfo()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objSubscriptionPurchaseViewModel.postCancelSubscriptionInfo(isCancelled: strCancelled) { result in
                KVSpinnerView.dismiss()
                
                switch result {
                case .success(let response):
                    // Handle successful
                    print(response)
                    
                case .failure(let error):
                    // Handle failure
                    print("error->\(error)")
                    break
                    
                }
            }
        }
        else
        {
            
        }
        
    }
    func apiCallPostSubscriptionInfo()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objSubscriptionPurchaseViewModel.postSubscription(productId: productId, transactionIdentifier: transactionIdentifier, transactionDate: transactionDate, transactionState: transactionState, productPrice: productPrice, productPriceLocal: productPriceLocal, productPurchaseCurrencyCode: productPurchaseCurrencyCode, planType: strPlanType) { result in
                
                KVSpinnerView.dismiss()
                
                switch result {
                case .success(let response):
                    // Handle successful
                    print(response)
                    
                    let strSubscriptionName = response.data.planName ?? "\(SubscibeUserType.free)"
                    if strSubscriptionName == SubscibeUserType.free {
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")
                    }
                    else if strSubscriptionName == SubscibeUserType.basic {
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.basic)", forKey: "SubscribedUserType")
                    }
                    else if strSubscriptionName == SubscibeUserType.premium {
                        UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.premium)", forKey: "SubscribedUserType")
                    }
                    
                    /*
                     AlertUtility.presentAlert(in: self, title: "Congratulations", message: "Product Purchased Successfully!!!", options: "Ok") { option in
                     switch(option) {
                     case 0:
                     self.navigationController?.popViewController(animated: true)
                     
                     break
                     
                     default:
                     break
                     }
                     }
                     */
                    
                    AlertUtility.presentSimpleAlert(in: self, title: "Congratulations", message: "Product Purchased Successfully!!!")
                    
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
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
        
    }
}
