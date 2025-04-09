//
//  NewsDeatilsVC.swift
//  TSS
//
//  Created by apple on 04/07/24.
//

import UIKit
import KVSpinnerView
import Photos
//import TwitterKit
import FBSDKShareKit

import LinkPresentation

class TikTokURLSharer {
    // TikTok URL Sharing Methods
    enum SharingMethod {
        case directOpen
        case deepLink
        case shareSheet
        case universalLink
    }
    
    /// Share URL to TikTok
    /// - Parameters:
    ///   - urlString: URL to share
    ///   - viewController: Current view controller for presenting alerts
    static func shareURL(_ urlString: String, in viewController: UIViewController) {
        // Validate URL
        guard let url = URL(string: urlString) else {
            showErrorAlert(in: viewController, message: "Invalid URL")
            return
        }
        
        // Sharing methods to attempt
        let sharingMethods: [SharingMethod] = [
            .directOpen,
            .deepLink,
            .shareSheet,
            .universalLink
        ]
        
        // Try each sharing method
        for method in sharingMethods {
            if attemptTikTokShare(url: url, method: method) {
                return
            }
        }
        
        // Fallback to system share sheet
        fallbackToActivityViewController(url: url, in: viewController)
    }
    
    /// Attempt to share URL using different TikTok methods
    private static func attemptTikTokShare(url: URL, method: SharingMethod) -> Bool {
        // Encode URL to handle special characters
        guard let encodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }
        
        // Generate TikTok URL based on sharing method
        var tiktokURL: URL?
        switch method {
        case .directOpen:
            tiktokURL = URL(string: "tiktok://open?url=\(encodedURL)")
        case .deepLink:
            tiktokURL = URL(string: "tiktok://app?url=\(encodedURL)")
        case .shareSheet:
            tiktokURL = URL(string: "tiktok://share?url=\(encodedURL)")
        case .universalLink:
            tiktokURL = URL(string: "https://www.tiktok.com/link?url=\(encodedURL)")
        }
        
        // Attempt to open URL
        guard let finalURL = tiktokURL else { return false }
        
        // Check if TikTok is installed
        if UIApplication.shared.canOpenURL(finalURL) {
            UIApplication.shared.open(finalURL) { success in
                print("TikTok sharing method \(method) - \(success ? "Succeeded" : "Failed")")
            }
            return true
        }
        
        return false
    }
    
    /// Fallback sharing method using activity view controller
    private static func fallbackToActivityViewController(url: URL, in viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        activityViewController.completionWithItemsHandler = { (_, completed, _, _) in
            if completed {
                print("Shared via system share sheet")
            }
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    /// Show error alert
    private static func showErrorAlert(in viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Sharing Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}


class InstagramURLSharer {
    // Different Instagram URL schemes to try
    enum InstagramScheme {
        case openURL
        case shareToStory
        case directShare
    }
    
    // Attempt to share URL to Instagram
    static func shareURL(_ urlString: String, in viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            showErrorAlert(in: viewController, message: "Invalid URL")
            return
        }
        
        // Try multiple sharing methods
        let sharingMethods: [InstagramScheme] = [
            .openURL,
            .shareToStory,
            .directShare
        ]
        
        for method in sharingMethods {
            if openInstagram(url: url, method: method) {
                return
            }
        }
        
        // Fallback to activity view controller
        fallbackToActivityViewController(url: url, in: viewController)
    }
    
    // Attempt to open Instagram with different URL schemes
    private static func openInstagram(url: URL, method: InstagramScheme) -> Bool {
        var instagramURL: URL?
        
        switch method {
        case .openURL:
            // Standard URL opening
            instagramURL = URL(string: "instagram://app?url=\(url.absoluteString)")
        case .shareToStory:
            // Share to Instagram Story (requires app)
            instagramURL = URL(string: "instagram-stories://share?url=\(url.absoluteString)")
        case .directShare:
            // Direct share attempt
            instagramURL = URL(string: "instagram://sharesheet?url=\(url.absoluteString)")
        }
        
        guard let finalURL = instagramURL else { return false }
        
        // Check if Instagram is installed and attempt to open
        if UIApplication.shared.canOpenURL(finalURL) {
            UIApplication.shared.open(finalURL) { success in
                print("Instagram URL method \(method) - \(success ? "Success" : "Failed")")
            }
            return true
        }
        
        return false
    }
    
    // Fallback sharing method using activity view controller
    private static func fallbackToActivityViewController(url: URL, in viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                print("Shared via activity view controller")
            }
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    // Show error alert if sharing fails
    private static func showErrorAlert(in viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Sharing Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
/*
class URLSharingManager {
    // Supported social media apps
    enum SocialApp: String {
        case tiktok = "tiktok://"
        case instagram = "instagram://"
    }
    
    // Check if app is installed
    static func isAppInstalled(_ app: SocialApp) -> Bool {
        guard let url = URL(string: app.rawValue) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    // Share URL via deep linking
    static func shareURL(_ urlString: String, to app: SocialApp, in viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            showErrorAlert(in: viewController, message: "Invalid URL")
            return
        }
        
        // Prepare share items
        let items: [Any] = [url]
        
        // Create activity view controller
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // Customize for specific apps if needed
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                print("Successfully shared to \(app)")
            }
        }
        
        // Present the activity view controller
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    // Open app directly with URL
    static func openApp(_ app: SocialApp, with urlString: String? = nil) {
        guard let baseURL = URL(string: app.rawValue) else { return }
        
        var finalURL = baseURL
        if let urlString = urlString, let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            finalURL = URL(string: "\(app.rawValue)open?url=\(encodedURL)") ?? baseURL
        }
        
        UIApplication.shared.open(finalURL) { success in
            if !success {
                print("Could not open \(app)")
            }
        }
    }
    
    // Helper method to show error alert
    static func showErrorAlert(in viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Sharing Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
*/
class NewsDeatilsVC: UIViewController {
    
    //  - Variables - 
    var userId: String = ""
    var postId: String = ""
    private let objBlogDetailsViewModell = blogDetailsViewModel()
    var objBlogDetailsResponse: blogDetailsResponse?

    //  - Outlets - 
    @IBOutlet weak var tblNewsDetails: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension NewsDeatilsVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.getUserId()
        self.registerNib()
        self.apiCallGetBlogDetails()
    }
}
//MARK: General Methods
extension NewsDeatilsVC
{
    /*
    func shareURLExample() {
            let urlToShare = "https://example.com"
            
            // Check if TikTok is installed
            if URLSharingManager.isAppInstalled(.tiktok) {
                // Option 1: Share via activity view controller
                URLSharingManager.shareURL(urlToShare, to: .tiktok, in: self)
                
                // Option 2: Open directly in TikTok
                URLSharingManager.openApp(.tiktok, with: urlToShare)
            }
            
            // Similar approach for Instagram
            if URLSharingManager.isAppInstalled(.instagram) {
                URLSharingManager.shareURL(urlToShare, to: .instagram, in: self)
            }
        }
    */
    
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["NewDetailTBC"], withNibNames: ["NewDetailTBC"], tbl: tblNewsDetails)
        tblNewsDetails.estimatedRowHeight = UITableView.automaticDimension
        tblNewsDetails.rowHeight = 934.0
        
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension NewsDeatilsVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension NewsDeatilsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewDetailTBC", for: indexPath) as! NewDetailTBC
        cell.delegate = self
       
        cell.configure(withResponse: objBlogDetailsResponse, withIndex: indexPath.row)
        cell.selectionStyle = .none
        
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
extension NewsDeatilsVC: NewDetailTBCDelegate
{
    func cell(_ cell: NewDetailTBC, linkdeInUrl: String) {
        print("SocialMediaUrl-->\(linkdeInUrl)")
        
        let strText = "Check out this link!"
        let url = linkdeInUrl

        let encodedText = strText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            // Combine text and URL for LinkedIn
            let linkedInURLString = "https://www.linkedin.com/sharing/share-offsite/?url=\(encodedURL)&title=\(encodedText)"
            
            // Open the URL
            if let url = URL(string: linkedInURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    func cell(_ cell: NewDetailTBC, btnViewAllTapped: String) {
        self.navigationController?.popViewController(animated: false)
    }
    func cell(_ cell: NewDetailTBC, relatedBlogPostId: String) {
        print("previousPostId-\(relatedBlogPostId)")
        postId = relatedBlogPostId
        self.apiCallGetBlogDetails()
    }
    func cell(_ cell: NewDetailTBC, faceBookUrl: String, sender: Any) {
        print("SocialMediaUrl-->\(faceBookUrl)")
        let urlString = faceBookUrl
        let strText = "Check out this link!"

        if let decodedURL = urlString.removingPercentEncoding {
            print("Decoded URL: \(decodedURL)")
            
            guard let url = URL(string: urlString) else {
                // Handle invalid URL
                let alert = UIAlertController(title: "Error", message: "Invalid URL.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            
            let encodedText = strText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            // Check if Facebook app is installed
            let facebookAppURL = URL(string: "fb://")!
            if UIApplication.shared.canOpenURL(facebookAppURL) {
                // Facebook app is installed, use ShareDialog
                let content = ShareLinkContent()
                content.contentURL = url
                content.quote = strText
                
                let dialog = ShareDialog(viewController: self, content: content, delegate: nil)
                dialog.mode = .automatic
                
                do {
                    try dialog.show()
                } catch {
                    // If ShareDialog fails, fallback to web browser
                    openInWebBrowser(encodedText: encodedText, encodedURL: encodedURL)
                }
            } else {
                // Facebook app is not installed, open in web browser
                openInWebBrowser(encodedText: encodedText, encodedURL: encodedURL)
            }
        }
    }

    func openInWebBrowser(encodedText: String, encodedURL: String) {
        let webURLString = "https://www.facebook.com/sharer/sharer.php?u=\(encodedURL)&quote=\(encodedText)"
        if let webURL = URL(string: webURLString) {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Unable to open the URL.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func cell(_ cell: NewDetailTBC, TwiiterURL: String) {
        print("SocialMediaUrl --> \(TwiiterURL)")

        // The text you want to share
        let strText = "Check out this link!"
        
        // URL you want to share
        let url = TwiiterURL

        // URL encode the text and the URL
        let encodedText = strText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // Create the URL scheme for Twitter app
        let urlString = "twitter://post?message=\(encodedText) \(encodedURL)"

        // Check if Twitter app can be opened
        if let twitterURL = URL(string: urlString), UIApplication.shared.canOpenURL(twitterURL) {
            // Open Twitter app to post
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        } else {
            // Fallback to web-based sharing
            let webURLString = "https://twitter.com/intent/tweet?text=\(encodedText)%20\(encodedURL)"
            if let webURL = URL(string: webURLString) {
                // Open Twitter's web share page
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            } else {
                print("Failed to open URL.")
            }
        }
    }
    func cell(_ cell: NewDetailTBC, instagramUrl: String)
    {
        let urlToShare = instagramUrl
              InstagramURLSharer.shareURL(urlToShare, in: self)
    }

    func cell(_ cell: NewDetailTBC, tikTokUrl: String) {
        // Similar approach for Instagram
      
        
        //Tiktok
        let urlToShare = tikTokUrl
                TikTokURLSharer.shareURL(urlToShare, in: self)
     
       
    }
    
    func cell(_ cell: NewDetailTBC, nextPostId: String) {
        print("nextPostId-\(nextPostId)")
        postId = nextPostId
        self.apiCallGetBlogDetails()
        
    }
    
    func cell(_ cell: NewDetailTBC, previousPostId: String) {
        print("previousPostId-\(previousPostId)")
        postId = previousPostId
        self.apiCallGetBlogDetails()
    }
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Show error message
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Image saved successfully, now share to Instagram
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if let asset = fetchResult.firstObject {
                let localIdentifier = asset.localIdentifier
                let urlScheme = "instagram://library?LocalIdentifier=\(localIdentifier)"
                
                if let instagramURL = URL(string: urlScheme) {
                    if UIApplication.shared.canOpenURL(instagramURL) {
                        // Open Instagram with the image
                        UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
                    } else {
                        // Show error message if Instagram is not installed
                        self.showAlert(title: "Instagram Unavailable", message: "Instagram is not installed on this device.")
                    }
                }
            }
        }
    }

    // Helper function to show alerts
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
//MARK: API Call
extension NewsDeatilsVC
{
    func apiCallGetBlogDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objBlogDetailsViewModell.blogDetails(postId: postId, userId: userId) { result in
                switch result {
                case .success(let response):
                    KVSpinnerView.dismiss()
                    print(response)
                   
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


