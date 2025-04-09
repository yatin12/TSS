//
//  AppDelegate.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import IQKeyboardManagerSwift
import KVSpinnerView
import Firebase
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import FirebaseAuth
import FBSDKCoreKit
import SwiftyStoreKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var fcmToken_Appdelegate: String?
    var DeviceToken: String = ""
    var restrictRotation : Bool! = false
    let objSubscriptionPurchaseViewModel = subscriptionPurchaseViewModel()

    func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)

      //  GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["042f3ff1bb25a2fdbc95b75c5984e5bf"]


        
        self.setupIAP()
        self.verifyRecipt()
        
        self.setUpIQKeyaboard()
        self.applyUserSelectedTheme()
        self.setUpSpinnerView()
        self.setUpUITabBar()
        self.registerForPushNotifications()
        self.fetchURLsFromPlist()
        

        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        /*
                for familyName:String in UIFont.familyNames {
                print("Family Name: \(familyName)")
                for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                print("--Font Name: \(fontName)")
                }
                }
        */
        
        return true
    }
    func applyUserSelectedTheme() {
       // UserDefaultUtility.saveValueToUserDefaults(value: "\(0)", forKey: "USERTHEME")

            let selectedIndex = UserDefaults.standard.integer(forKey: "USERTHEME")
            var userInterfaceStyle: UIUserInterfaceStyle

            switch selectedIndex {
            case 0:
                userInterfaceStyle = .unspecified // System default
            case 1:
                userInterfaceStyle = .light
            case 2:
                userInterfaceStyle = .dark
            default:
                userInterfaceStyle = .unspecified
            }

            if let window = UIApplication.shared.windows.first {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    func setUpIQKeyaboard()
    {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    func setUpSpinnerView()
    {
        KVSpinnerView.settings.animationStyle = .standart
        KVSpinnerView.settings.backgroundRectColor = AppColors.ThemePinkColor
        KVSpinnerView.settings.tintColor = .white
    }
    func setUpUITabBar()
    {
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().tintColor = .white
        
//        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "ThemePinkColor")
//        UITabBar.appearance().tintColor = UIColor(named: "ThemePinkColor")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: AppFontName.Poppins_SemiBold.rawValue, size: 11)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: AppFontName.Poppins_SemiBold.rawValue, size: 11)!], for: .selected)
        
    }
    func fetchURLsFromPlist()
    {
        
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let url = plist["PrivacyPolicyURL"] as? String {
            // Use the apiKey variable here
            PrivacyPolicyURL = url
        }
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let url = plist["TermsConditionURL"] as? String {
            // Use the apiKey variable here
            termsConditionURL = url
        }
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let url = plist["aboutUSURL"] as? String {
            // Use the apiKey variable here
            aboutUSURL = url
        }
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let url = plist["PodCastURL"] as? String {
            // Use the apiKey variable here
            PodCastURL = url
        }
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: filePath),
           let url = plist["FoundationURL"] as? String {
            // Use the apiKey variable here
            foundationURL = url
        }
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        let handledByFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        // Return true if either Facebook or Google handled the URL
        return handledByFacebook
    }
    
    //MARK: - Firebase Notification
    
    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
                
                if error == nil {
                    
                    DispatchQueue.main.async(execute: {
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            })
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.hexString
        DeviceToken = deviceTokenString
        // kDEVICEKEYVALUE  = deviceTokenString
        
        UserDefaultUtility.saveValueToUserDefaults(value: "\(DeviceToken)", forKey: "DEVICETOKEN")
        
        Messaging.messaging().apnsToken = deviceToken
        
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator :( \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        //  print("userInfo-->\(userInfo)")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[gcmMessageIDKey]
        {
            debugPrint("Message ID: \(messageID)")
        }
        // Print full message.
        debugPrint(userInfo)
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
        // print("DEBUG: Device Token - \(deviceToken) ")
    }
    
    
    // MARK: - FCM
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let token:String = fcmToken ?? ""
        fcmToken_Appdelegate = token
        
         print("FCMTOKEN-->\(fcmToken_Appdelegate ?? "")")
        
        UserDefaultUtility.saveValueToUserDefaults(value: "\(fcmToken_Appdelegate ?? "")", forKey: "FCMTOKEN")
        
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        //print("DEBUG: DNS Token - \(token) ")
    }
    
    // MARK: - Notification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        _ = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        // print("userInfo->\(userInfo)")
        
        completionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([.sound, .badge, .banner])
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.restrictRotation {
            // Allow all orientations when rotation is not restricted
            return .all
        } else {
            // Check if the top view controller is VideoDetailsVC
            if let topVC = window?.rootViewController?.topMostViewController() {
                if topVC is VideoDetailsVC || topVC is HomeVC {
                    // Allow all orientations for VideoDetailsVC
                    return .all
                }
            }
            // Default to portrait orientation
            return .portrait
        }
    }
    
    //MARK: - IN App Purchase
    func verifyRecipt()
    {
        let purchasesToVerify: Set<String> = [inappPurchaseIds.Basic_Monthly, inappPurchaseIds.Basic_Yearly, inappPurchaseIds.Premium_Yearly, inappPurchaseIds.Premium_Monthly ]
        verifySubscriptions(purchasesToVerify)
    }
    func setupIAP() {

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in

            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in

            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func verifySubscriptions(_ purchases: Set<String>) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: purchases, inReceipt: receipt)
                self.alertForVerifySubscriptions(purchaseResult, productIds: purchases)
            case .error:
                print("error-->\(result)")
                //self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) {

        switch result {
        case .purchased(let expiryDate, let items):
            // To save "YES"
            purchaseUtility.setProductPurchased(true)
            isProductPurchased = true
            var strPlanType: String = ""
            
            if let firstItem = items.first {
                if firstItem.productId == inappPurchaseIds.Basic_Monthly ||  firstItem.productId == inappPurchaseIds.Premium_Monthly 
                {
                    strPlanType = "\(SubscibeUserType.basic)"
                    UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.basic)", forKey: "SubscribedUserType")

                }
                else if firstItem.productId == inappPurchaseIds.Basic_Yearly || firstItem.productId == inappPurchaseIds.Premium_Yearly
                {
                    strPlanType = "\(SubscibeUserType.premium)"
                    UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.premium)", forKey: "SubscribedUserType")

                }
            }
            UserDefaultUtility.saveValueToUserDefaults(value: strPlanType, forKey: "whichPlanPurchased")
            strCancelled = "NO"
            
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            print("Product is purchased and Product is valid until \(expiryDate)")
            
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            print("Product expired and Product is expired since \(expiryDate)")
            
            
            UserDefaultUtility.saveValueToUserDefaults(value: "", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            purchaseUtility.setProductPurchased(false)
            isProductPurchased = false
            strCancelled = "YES"
            self.apiCallPostCancelSubscriptionInfo()
            
           // return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            purchaseUtility.setProductPurchased(false)
            isProductPurchased = false
            strCancelled = "NO"
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "whichPlanPurchased")
            UserDefaultUtility.saveValueToUserDefaults(value: "\(SubscibeUserType.free)", forKey: "SubscribedUserType")

            
            print("\(productIds) has never been purchased")
            print("This product has never been purchased")

            
          //  return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: inappSharedSecretKey) //Khushbu Change
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
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
    /*
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
                    /*
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        // print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                    }
                    */
                }
            }
        }
        else
        {
           // AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
        
    }
    */
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
