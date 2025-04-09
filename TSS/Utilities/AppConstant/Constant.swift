//
//  Constant.swift
//  Uveaa Solar
//
//  Created by apple on 12/01/24.
//

import UIKit


var hasVideoPlayed1 = false
let inappSharedSecretKey: String = "5cee24ff0c6c4806bd3934db9a0aaee1"
let testAdmobId: String = "ca-app-pub-3940256099942544/2934735716"

let LiveAdmobId: String = "ca-app-pub-3996099707576962/1670771947"
//let LiveAdmobId: String = "ca-app-pub-3940256099942544/2934735716"


enum AppEnvironment {
    case production
    case beta
}
struct inappPurchaseIds {
    
    static let Basic_Monthly: String = "com.thesistersshowllc.basicMonthly"
    static let Premium_Monthly: String  = "com.thesistersshowllc.premiumMonthly"
    static let Basic_Yearly: String  = "com.thesistersshowllc.basicYearly"
    static let Premium_Yearly: String  = "com.thesistersshowllc.premiumYearly"

}
struct SubscibeUserType {
    
    static let free:String = "Free"
    static let basic:String = "Basic"
    static let premium:String = "Premium"
}


var isFromPrivacyViewSetting: Bool = false
var isFromTermsViewSetting: Bool = false
var strPlanType: String = "monthly"
var isProductPurchased: Bool = false
var strCancelled: String = "NO"
let dateFormate = "yyyy-MM-dd"

let currentEnvironment: AppEnvironment = .production
let AppUserDefaults = UserDefaults.standard
var strSelectedBlog: String = ""
var isFromViewAll: Bool = false
let highlightColor = UIColor(named: "ThemeHighlightBorderColor")?.cgColor ?? UIColor.clear.cgColor
let DefaultBorderColor = UIColor(named: "ThemeDefaultBorderColor")?.cgColor ?? UIColor.clear.cgColor

let highlightColor_Lbl = UIColor(named: "ThemeHighlightBorderColor") ?? UIColor.clear
let DefaultBorderColor_Lbl = UIColor(named: "ThemeFontColor") ?? UIColor.clear

let clearColor = UIColor.clear.cgColor
var strSelectedPostName: String = ""
let imageSelected = UIImage(named: "icn_Radio_Select")
let imageUnselected = UIImage(named: "icn_Radio_UnSelect")
let lightFont = UIFont(name: "Poppins-Light", size: 12) ?? UIFont.boldSystemFont(ofSize: 17)
let mediumFont = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 17)
let boldFont = UIFont(name: "Poppins-Bold", size: 26) ?? UIFont.systemFont(ofSize: 26)

let lightAttributes: [NSAttributedString.Key: Any] = [
    .font: lightFont
]
let mediumAttributes: [NSAttributedString.Key: Any] = [
    .font: mediumFont
]
let boldAttributes: [NSAttributedString.Key: Any] = [
    .font: boldFont
]

let semiBoldFont = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14)
//let boldFontSubscriber = UIFont(name: "Poppins-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)

let boldSubscribeAttributes: [NSAttributedString.Key: Any] = [
    .font: semiBoldFont,
    .foregroundColor: UIColor(named: "ThemePinkColor")!
]
let semiBoldAttributes: [NSAttributedString.Key: Any] = [
    .font: semiBoldFont
]
//EndPoint
let loginEndpoint = "login"
let addFCMTokenEndpoint = "fcmtoken"

let registerEndpoint = "register"
let blog_categoriesEndpoint = "blog_categories"
let get_blogs_by_categoryEndpoint = "get_blogs_by_category"
let blog_details_by_pageidEndpoint = "blog_details_by_pageid"
let get_favourite_listEndpoint = "get_favourite_list"
let get_watchlistEndpoint = "get_watchlist"
let e_videoDetailEndpoint = "e_video_detail"
let getProfileEndpoint = "user-profile"
let updateProfileEndpoint = "update-user-profile"
let countryListEndpoint = "country_list"
let videoRateEndpoint = "video_submit_rating"
let getVideoListEndpoint = "e_videos_by_category_id"
let getTalkShowListEndpoint = "talk_shows_by_category_id"
let addWatchlistEndpoint = "add_watchlist"
let deleteWatchlistEndpoint = "delete_watchlist"
let sendContactDetailsEndpoint = "contact-form-submit"
let membershipPlanEndpoint = "membership-plans"
let subscriptionPurchaseEndpoint = "subscription_purchase_Info"
let UpcomingEventPurchaseEndpoint = "upcoming-event-payment"

let favVideoEndpoint = "like_unlike"
let searchEndpoint = "search"
let HomeEndpoint = "homepage"
let forgotPasswordEndpoint = "reset-password"
let deleteAccountEndpoint = "delete-account"
let logoutEndpoint = "user-logout"
let liveShowDetailsEndpoint = "get-liveshow-detail"
let UpcomingEventsEndpoint = "upcoming-event-list"

var strSlectedBlogCatNews: String = ""

let ServerDateFormat = "dd/MM/yyyy"
var PrivacyPolicyURL: String = ""
var termsConditionURL: String = ""
var PodCastURL: String = ""
var aboutUSURL: String = ""
var foundationURL: String = ""
var Season1TBSURL: String = ""

struct subscriptionPlanTime {
    static let Year:String = "Year"
    static let Month:String = "Month"
}
struct USERROLE {
    
    static let GuestUser:String = "GuestUser"
    static let SignInUser:String = "SignInUser"
}
struct blogCategories {
    
    static let Evideo:String = "Evideo"
    static let TalkShow:String = "TalkShow"
    static let News:String = "News"
}

extension DateFormatter
{
    static func convertDateToStringForserver(inputDate: Date) -> String? {
        let dateFormatter = DateFormatter()
        // dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateFormatter.dateFormat = ServerDateFormat
        return dateFormatter.string(from: inputDate)
    }
}
  
struct storyboardKey {
    static let IntroScreen:String = "IntroScreen"
    static let InnerScreen:String = "InnerScreen"
    static let ProfileScreen:String = "ProfileScreen"
}

class purchaseUtility
{
    static func setProductPurchased(_ isPurchased: Bool) {
        let value = isPurchased ? "YES" : "NO"
        UserDefaultUtility.saveValueToUserDefaults(value: value, forKey: "isProductPurchased")
    }
}

struct AlertMessages {
    static let NoInternetAlertMsg = "Whoops! Internet connection not available!"
    static let ErrorAlertMsg = "Whoops! Something went wrong. Please try again."
    static let RoleMsg = "You are not allowed."
    static let BlankEmail:String = "Email ID is mandatory."
    static let InvalidEmail:String = "Invalid email ID."
    static let BlankPassword:String = "Password is mandatory."
    static let PasswordLength:String = "Minimum 8 characters are required in password."
    static let BlankUserNm:String = "UserName is mandatory."
    static let BlankConfirmPassword:String = "Confirm password cannot be blank."
    static let ConfirmPasswordLength:String = "Confirm password must minimum 8 characters."
    static let MatchPasswordReg:String = "Confirm password must match with password."
    static let BlankName:String = "Name is mandatory."
    static let BlankMessage:String = "Message is mandatory."
    static let LogoutMsg:String = "Do you want to logout?"
    static let deleteAccountMsg:String = "Do you want to delete account?"
    static let RateMsg:String = "Please give some rate by pressing a star. Thank you!"
    static let RateMsg1:String = "Please give some comments. Thank you!"

    static let ForceFullyRegister:String = "To access all content, please register."
    static let subscribeMsg: String = "Please subscribe to continue watching."
    static let subscribeForTabMsg: String = "Access to this content is restricted; please subscribe to view it."
}

class AppUtility {
    static func fetchBuildVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "Version \(appVersion ?? "1.0.0")"
    }
    
}

struct TimeAgoUtility
{
   static func timeAgoSinceDate(date: Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day], from: date, to: now)
            
            if let years = components.year, years > 0 {
                return "\(years) year\(years > 1 ? "s" : "") ago"
            }
            
            if let months = components.month, months > 0 {
                return "\(months) month\(months > 1 ? "s" : "") ago"
            }
            
            if let days = components.day, days > 0 {
                return "\(days) day\(days > 1 ? "s" : "") ago"
            }
            
            return "Today"
        }
}
struct NotificationCountUtility {
    
    static func setNotificationCount() -> (count: String, hasUnread: Bool) {
        if let cnt = AppUserDefaults.object(forKey: "NotificationUnreadCount") as? String {
            // Check if the count is greater than 0 to determine if there are unread notifications
            
            //  var isNotitiCntViewHidden: Bool = true
            let isNotitiCntViewHidden = cnt == "0" ? true : false
            return (cnt, isNotitiCntViewHidden)
        } else {
            // Default to "0" count and no unread notifications
            return ("0", true)
        }
    }
}

struct UserDefaultUtility {
    
    static func saveValueToUserDefaults(value: Any, forKey key: String) {
        AppUserDefaults.setValue(value, forKey: key)
        AppUserDefaults.synchronize()
    }
}
struct AlertUtility {
    
    static func presentAlert(in viewController: UIViewController, title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default) { _ in
                completion(index)
            })
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func presentSimpleAlert(in viewController: UIViewController, title: String?, message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
class DeviceUtility {
    static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            if let keyWindow = UIApplication.shared.windows.first {
                return keyWindow.safeAreaInsets.bottom > 0
            }
        }
        return false
    }
    
    static func setHeaderViewHeight(_ constHeightHeader: NSLayoutConstraint) {
        if hasNotch {
            constHeightHeader.constant = 100
        } else {
            constHeightHeader.constant = 80
        }
    }
    
    static func setAutoCompleteHeaderViewHeight(_ constHeightHeader: NSLayoutConstraint) {
        if hasNotch {
            constHeightHeader.constant = 150
        } else {
            constHeightHeader.constant = 130
        }
    }
}
class GenericFunction
{
    static func setPlaceholderColor(for textField: UITextField) {
        let color: UIColor = .placeholder
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [.foregroundColor: color])
    }
    static func registerNibs(for cellIdentifiers: [String], withNibNames nibNames: [String], tbl: UITableView) {
        guard cellIdentifiers.count == nibNames.count else {
            // The number of cell identifiers and nib names should be the same
            return
        }
        
        for (index, identifier) in cellIdentifiers.enumerated() {
            tbl.register(UINib(nibName: nibNames[index], bundle: .main), forCellReuseIdentifier: identifier)
        }
    }

   
}
extension Data {
    
    var hexString: String {
        
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
struct NavigationHelper {
    static func push(_ storyboardName: String, viewControllerIdentifier: String, from navigationController: UINavigationController, animated: Bool) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    static func pushWithPassData(_ storyboardName: String, viewControllerIdentifier: String, from navigationController: UINavigationController, data: Any? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? NewsDeatilsVC {
            
            if let selectedPostId = data as? String {
                viewController.postId = selectedPostId
            } else {
                fatalError("Invalid data type passed to EditProfileVC. Expected GetProfileResponse, received \(String(describing: data))")
            }
            
            navigationController.pushViewController(viewController, animated: true)
        }
        else if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? VideoDetailsVC {
            
            if let selectedPostId = data as? String {
                viewController.videoId = selectedPostId
            } else {
                fatalError("Invalid data type passed to EditProfileVC. Expected GetProfileResponse, received \(String(describing: data))")
            }
            
            navigationController.pushViewController(viewController, animated: true)
        }
        else if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? MeetSisterPageVC {
            
            if let selectedPostURL = data as? String {
                viewController.strSisterUrl = selectedPostURL
            } else {
                fatalError("Invalid data type passed to EditProfileVC. Expected GetProfileResponse, received \(String(describing: data))")
            }
            
            navigationController.pushViewController(viewController, animated: true)
        }
       
        else {
            fatalError("ViewController with identifier \(viewControllerIdentifier) not found or does not conform to EditProfileVC.")
        }
        
    }
    
    static func pushWithSignaturePassData(_ storyboardName: String, viewControllerIdentifier: String, from navigationController: UINavigationController, data: Any? = nil, data1: Any? = nil)
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? MembershipLevelVC {
            
            if let strJobId = data as? Int {
                viewController.idx = strJobId
            }
            else {
                fatalError("Invalid data type passed to EditProfileVC. Expected GetProfileResponse, received \(String(describing: data))")
            }
            
            if let strParam = data1 as? membershipPlanResponse {
                viewController.objMembershipPlanResponse = strParam
            }
            else {
                fatalError("Invalid data type passed to EditProfileVC. Expected GetProfileResponse, received \(String(describing: data))")
            }
            
            
            
            navigationController.pushViewController(viewController, animated: true)
        }

        
        else {
            fatalError("ViewController with identifier \(viewControllerIdentifier) not found or does not conform to EditProfileVC.")
        }
    }
    
}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var CshadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print("Error converting HTML string: \(error.localizedDescription)")
            return nil
        }
    }
    
    func htmlToString() -> String {
        return htmlToAttributedString()?.string ?? ""
    }
    func removingHTMLEntities() -> String {
            return self.replacingOccurrences(of: "&#8217;", with: "'")
        }
    func decodingHTMLEntities() -> String? {
            guard let data = self.data(using: .utf8) else { return nil }
            
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
            return attributedString.string
        }
    
}

