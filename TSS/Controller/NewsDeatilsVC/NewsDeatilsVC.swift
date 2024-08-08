//
//  NewsDeatilsVC.swift
//  TSS
//
//  Created by apple on 04/07/24.
//

import UIKit
import KVSpinnerView
import Photos

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
    func cell(_ cell: NewDetailTBC, faceBookUrl: String, sender: Any) {
        print("faceBookUrl-\(faceBookUrl)")
        
        let text = "Check out this link!"
        if let url = URL(string: "https://test.fha.nqn.mybluehostin.me/?p=11480") {
            let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
            
            // Exclude unnecessary activities if needed
            activityViewController.excludedActivityTypes = [.postToWeibo, .print, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .postToTencentWeibo, .airDrop]
            
            // For iPads, we need to specify a source view to prevent crashes
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                if let button = sender as? UIView {
                    popoverPresentationController.sourceRect = button.bounds
                }
            }
            
            // Present the view controller
            present(activityViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid URL.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func cell(_ cell: NewDetailTBC, instagramUrl: String) {
        print("instagramUrl-\(instagramUrl)")
        
        guard let videoURL = URL(string: "https://test.fha.nqn.mybluehostin.me/?p=11480") else {
            print("Invalid URL")
            return
        }
        // Example image to share
        guard let image = UIImage(named: "exampleImage") else {
            print("Image not found")
            return
        }
        // Save image to photo library
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    func cell(_ cell: NewDetailTBC, tikTokUrl: String) {
        print("tikTokUrl-\(tikTokUrl)")
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


