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

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var fcmToken_Appdelegate: String?
    var DeviceToken: String = ""

    func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setUpIQKeyaboard()
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
        
//        for familyName:String in UIFont.familyNames {
//        print("Family Name: \(familyName)")
//        for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
//        print("--Font Name: \(fontName)")
//        }
//        }
        
        return true
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
        
        
        
    }
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
        
        // print("FCMTOKEN-->\(fcmToken_Appdelegate ?? "")")
        
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
}

