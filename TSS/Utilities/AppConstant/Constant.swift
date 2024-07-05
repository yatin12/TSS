//
//  Constant.swift
//  Uveaa Solar
//
//  Created by apple on 12/01/24.
//

import UIKit
import CoreLocation

enum AppEnvironment {
    case production
    case beta
}


let currentEnvironment: AppEnvironment = .beta
let AppUserDefaults = UserDefaults.standard
var isFromViewAll: Bool = false
let highlightColor = UIColor(named: "ThemeHighlightBorderColor")?.cgColor ?? UIColor.clear.cgColor
let clearColor = UIColor.clear.cgColor

let lightFont = UIFont(name: "Poppins-Light", size: 12) ?? UIFont.boldSystemFont(ofSize: 17)
let mediumFont = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.systemFont(ofSize: 17)

let lightAttributes: [NSAttributedString.Key: Any] = [
    .font: lightFont
]
let mediumAttributes: [NSAttributedString.Key: Any] = [
    .font: mediumFont
]



//EndPoint
let loginEndpoint = "login"
let registerEndpoint = "register"

let forgotPasswordEndpoint = "installer/forgot-password"
let ServerDateFormat = "dd/MM/yyyy"
let PrivacyPolicyURL: String = ""
let termsConditionURL: String = ""
let aboutUSURL: String = ""

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

}

class AppUtility {
    static func fetchBuildVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "Version \(appVersion ?? "1.0.0")"
    }
}
struct locationUtility
{
    static func calculateDistanceBetween(coordinateA: CLLocationCoordinate2D, coordinateB: CLLocationCoordinate2D) -> CLLocationDistance {
        let locationA = CLLocation(latitude: coordinateA.latitude, longitude: coordinateA.longitude)
        let locationB = CLLocation(latitude: coordinateB.latitude, longitude: coordinateB.longitude)
        return locationA.distance(from: locationB)
    }
    
    static func calculateDistanceBetweenLocationsInMeter(latCurrent: Double, longCurrent: Double, latCustomer: Double, longCustomer: Double) -> Double {
        // Coordinates of point A
        let coordinateSource = CLLocationCoordinate2D(latitude: latCurrent, longitude: longCurrent)
        
        // Coordinates of point B
        let coordinateDestination = CLLocationCoordinate2D(latitude: latCustomer, longitude: longCustomer)
        
        // Calculate distance between points A and B
        let locationA = CLLocation(latitude: coordinateSource.latitude, longitude: coordinateSource.longitude)
        let locationB = CLLocation(latitude: coordinateDestination.latitude, longitude: coordinateDestination.longitude)
        let distance = locationA.distance(from: locationB)
        
        // Convert distance to kilometers
        return distance
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
        
    }
    
    static func pushWithSignaturePassData(_ storyboardName: String, viewControllerIdentifier: String, from navigationController: UINavigationController, data: Any? = nil, data1: Any? = nil)
    {
        
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
