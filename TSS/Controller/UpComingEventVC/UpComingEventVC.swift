import UIKit
import KVSpinnerView
import SwiftyStoreKit
import PassKit
import BraintreeCore
import BraintreeApplePay

class UpComingEventVC: UIViewController {
    private let objUpcomingEventViewModel = upcomingEventViewModel()
    var objUpcomingEventResponse: upcomingEventResponse?
    // var strProductId: String = ""
    var pageNo: Int = 1
    var isLoadingList : Bool = false
    var strPlanPrice: String = ""
    var productPurchaseCurrencyCode: String = ""
    var postid: String = ""
    var productId: String = ""
    var transactionIdentifier: String = ""
    var transactionDate: String = ""
    var transactionState: String = ""
    var productPrice: String = ""
    var productPriceLocal: String = ""
    var purchasedEventIds: Set<String> = []
    let merchantID = "merchant.com.thesistersshowllc.thesistershow"
    var clientToken = ""
    let objUpcomingEventPurchaseViewModel = UpcomingEventPurchaseViewModel()
    let objGetPaypalTokenViewModel = GetPaypalTokenViewModel()
    var showErrorAlert = false
    var applePayHandler: ApplePayHandler?
    var paymentErrorMessage: String = ""
    var strPaypalNonce: String = ""
    var objpaypalNonceSubmitViewModel = eventPaypalNonceSubmitViewModel()
    
    var showSuccessAlert = false
    var strAmount: String = ""
    var strSelectedProductId: String = ""
    var selectedEventTitle: String = ""
    var userId: String = ""
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblUpComingEvent: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension UpComingEventVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpHeaderView()
        self.GetUpcomingList()
        
    }
    
}
//MARK: General Methods
extension UpComingEventVC
{
    @objc func loadData() {
        pageNo += 1
        self.apiCallGetUpcomingEventsList()
    }
    func GetUpcomingList()
    {
        self.pageNo = 1
        self.isLoadingList = false
        self.apiCallGetUpcomingEventsList()
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["UpComingTBC"], withNibNames: ["UpComingTBC"], tbl: tblUpComingEvent)
        tblUpComingEvent.estimatedRowHeight = UITableView.automaticDimension
        tblUpComingEvent.rowHeight = 400
        lblNoData.isHidden = true
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension UpComingEventVC
{
    @IBAction func btnBackTappe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension UpComingEventVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objUpcomingEventResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTBC", for: indexPath) as! UpComingTBC
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
        
        let currentEventId = "\(objUpcomingEventResponse?.data?[indexPath.row].id ?? "")"
        let strProductId = "\(objUpcomingEventResponse?.data?[indexPath.row].productId ?? "")"
        
        
        let strIspurchased = "\(objUpcomingEventResponse?.data?[indexPath.row].ispurchased ?? "NO")"
        
        let strEventPrice = "\(objUpcomingEventResponse?.data?[indexPath.row].eventPrice ?? "0")"

        
        if strIspurchased == "YES"
        {
            cell.btnPriceOutlt.setTitle("Purchased", for: .normal)
        }
        else
        {
            cell.strPrice = strEventPrice
            cell.btnPriceOutlt.setTitle("Price - $ \(strEventPrice)", for: .normal)
        }
        
        
        cell.configure(withResponse: objUpcomingEventResponse, withIndex: indexPath.row, purchasedEventIds: purchasedEventIds)
        
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadData()
        }
    }
}
//MARK: UpComingTBCDelegate
extension UpComingEventVC: UpComingTBCDelegate
{
    func cell(_ cell: UpComingTBC, price: String, idx: Int) {
        print("price==\(price)")

        self.postid = "\(objUpcomingEventResponse?.data?[idx].id ?? "")"
        self.selectedEventTitle = cell.lblEventTitle.text ?? ""
        self.strAmount = price
        self.strSelectedProductId = "\(objUpcomingEventResponse?.data?[idx].productId ?? "")"

        self.apiCallToGetPaypalToken()
    }
}
//MARK: Apple Pay and Paypal API Calls
extension UpComingEventVC
{
    func apiCallToGetPaypalToken() {

        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()

            Task {
                let response = await objGetPaypalTokenViewModel.getPaypalToken(userId: userId)
                KVSpinnerView.dismiss()

                if let response = response {
                    print(response.settings?.success ?? "No success flag")

                    if response.settings?.success == true {
                        print("Get Virtual Token successfully")
                        clientToken = response.data ?? ""
                         startApplePay()
                    } else {
                        print("API error: \(response.settings?.message ?? "Unknown server message")")
                        AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
                    }
                } else {
                    print("ViewModel error: \(objGetPaypalTokenViewModel.errorMessage ?? "Unknown error")")
                    AlertUtility.showAlert(message: objGetPaypalTokenViewModel.errorMessage ?? "Something went wrong")
                }
                    
            }
        } else {
            AlertUtility.showAlert(message: AlertMessages.NoInternetAlertMsg)
        }
    }
    func sanitizedAmount(from priceString: String) -> String {
        let filtered = priceString.filter { "0123456789.".contains($0) }
        return filtered.isEmpty ? "0" : filtered
    }
    func startApplePay() {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            // Device/region doesn't support Apple Pay at all
            showErrorAlert = true
            paymentErrorMessage = "Apple Pay is not available on this device."
            return
        }

        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard, .amex]) else {
            // Apple Pay is supported, but no card is set up yet
            showErrorAlert = true
            paymentErrorMessage = "Please add a card to Apple Wallet to use Apple Pay."
            return
        }
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: selectedEventTitle.isEmpty ? "Event" : selectedEventTitle, amount: NSDecimalNumber(string: sanitizedAmount(from: strAmount)))
        ]

        
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
           let braintreeClient = BTAPIClient(authorization: clientToken) {
            
            let handler = ApplePayHandler(
                braintreeClient: braintreeClient,
                nonceHandler: { nonce in
                    DispatchQueue.main.async {
                        self.strPaypalNonce = nonce
                        self.apiCallToSubmitPaypalNonceData()
                    }
                },
                completion: { success in
                    DispatchQueue.main.async {
                           if !success {
                               self.paymentErrorMessage = "Unable to complete payment."
                               self.showErrorAlert = true
                           }
                       }
                }
            )
            
            self.applePayHandler = handler
            controller.delegate = handler
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(controller, animated: true)
            }
        } else {
            showErrorAlert = true
            paymentErrorMessage = "Failed to initiate Apple Pay."
        }
    }
    func apiCallToSubmitPaypalNonceData() {

        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()

            Task {
                let response = await
                objpaypalNonceSubmitViewModel.submitEventPaypalNonceDetails(userId: userId, Nonce: strPaypalNonce, strAmount: strAmount, strProductID: strSelectedProductId)

                KVSpinnerView.dismiss()

                if let response = response {
                    print(response.settings?.success ?? "No success flag")

                    if response.settings?.success == true {
                        print("Nonce Wellness data submitted successfully")
                        showSuccessAlert = true          // ✅ no more AlertUtility.showAlert here
                    } else {
                        print("API error: \(response.settings?.message ?? "Unknown server message")")
                        paymentErrorMessage = response.settings?.message ?? "Something went wrong"
                        showErrorAlert = true             // ✅ real failure → real error alert
                    }
                } else {
                    print("ViewModel error: \(objpaypalNonceSubmitViewModel.errorMessage ?? "Unknown error")")
                    paymentErrorMessage = objpaypalNonceSubmitViewModel.errorMessage ?? "Something went wrong"
                    showErrorAlert = true
                }
            }
        } else {
            paymentErrorMessage = AlertMessages.NoInternetAlertMsg
            showErrorAlert = true
        }
    }
}
/*
//MARK: IN App Purchase
extension UpComingEventVC
{
    func purchase(_ inappPurchaseId: String, atomically: Bool, cell: UpComingTBC) {
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
            
            
            if let alert = self.alertForPurchaseResult(result, cell: cell) {
                self.showAlert(alert)
            }
            
        }
    }
    func alertForPurchaseResult(_ result: PurchaseResult, cell: UpComingTBC) -> UIAlertController? {
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
            // UserDefaultUtility.saveValueToUserDefaults(value: strPlanType, forKey: "whichPlanPurchased")
            
            self.apiCallPostUpcomingPurchaseInfo(cell: cell)
            
            return nil
        case .error(let error):
            
            print("Purchase Failed: \(error)")
            purchaseUtility.setProductPurchased(false)
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            
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
            isProductPurchased = false
            
            return alertWithTitle("deferred", message: "deferred")
        }
    }
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    func apiCallPostUpcomingPurchaseInfo(cell: UpComingTBC)
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            
            objUpcomingEventPurchaseViewModel.postUpcomingEventPurchaseInfo(postid: postid, productId: productId, transactionIdentifier: transactionIdentifier, transactionDate: transactionDate, transactionState: transactionState, productPrice: productPrice, productPriceLocal: productPriceLocal, productPurchaseCurrencyCode: productPurchaseCurrencyCode) { result in
                
                KVSpinnerView.dismiss()
                
                switch result {
                case .success(let response):
                    // Handle successful
                    print(response)
                    
                    self.purchasedEventIds.insert(self.postid)
                    cell.btnPriceOutlt.setTitle("Purchased", for: .normal)
                    
                    
                    AlertUtility.presentAlert(in: self, title: "Congratulations", message: "Upcoming Event Purchased Successfully!!!", options: "Ok") { option in
                        switch(option) {
                        case 0:
                            self.tblUpComingEvent.reloadData()
                            
                            
                            break
                            
                        default:
                            break
                        }
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
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
        
    }
}
*/
extension UpComingEventVC
{
    func apiCallGetUpcomingEventsList() {
        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()
            
            objUpcomingEventViewModel.getUpcomingList(userId: userId, pagination_number: "\(pageNo)") { result in
                switch result {
                case .success(let response):
                    
                    print(response)
                    
                    // Check if the response is successful
                    if response.settings?.success == true {
                        let newData = response.data ?? []
                        
                        if newData.count > 0 {
                            // If it's the first page, initialize or reset the data
                            if self.pageNo == 1 {
                                self.objUpcomingEventResponse = response
                            } else {
                                self.objUpcomingEventResponse?.data?.append(contentsOf: newData)
                            }
                            
                            self.isLoadingList = false
                            self.tblUpComingEvent.isHidden = false
                            self.lblNoData.isHidden = true
                        } else {
                            // Handle case where data is empty for pages other than the first
                            if self.pageNo == 1 {
                                self.objUpcomingEventResponse = response
                            }
                            self.tblUpComingEvent.isHidden = self.pageNo == 1
                            self.lblNoData.isHidden = self.pageNo != 1
                        }
                        KVSpinnerView.dismiss()
                        self.tblUpComingEvent.dataSource = self
                        self.tblUpComingEvent.delegate = self
                        self.tblUpComingEvent.reloadData()
                        
                    } else {
                        KVSpinnerView.dismiss()
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")
                    }
                    
                case .failure(let error):
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                    }
                }
            }
            
        } else {
            KVSpinnerView.dismiss()
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
}
extension UpComingEventVC
{
    func getPurchaseInfo(inappPurchaseId: String, completion: @escaping (Double?, String?, String?) -> Void) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([inappPurchaseId]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let price = product.price.doubleValue
                //                let currencySymbol = product.priceLocale.currencyCode ?? "Unknown Currency"
                let currencySymbol = product.priceLocale.currencySymbol ?? "Unknown Currency"
                
                let currencyCode = product.priceLocale.currencyCode ?? "Unknown Currency Code"
                print("product.localizedDescription-->\(product.localizedDescription)")
                print("price-->\(price)")
                print("Currency Symbol: \(currencySymbol)")
                print("Currency Code: \(currencyCode)")
                //  let currencyCode = product.priceLocale.currencyCode ?? "Unknown Currency"
                
                
                
                // Get country name based on the currency code
                
                completion(price, currencySymbol, currencyCode)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
}
