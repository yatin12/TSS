//
//  AboutUsVC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit
import WebKit
import KVSpinnerView

class AboutUsVC: UIViewController {
    
    //  - Variables - 
    @IBOutlet weak var objWebView: WKWebView!

    //  - Outlets - 
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
extension AboutUsVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.loadAboutUsURL()
    }
}
//MARK: General Methods
extension AboutUsVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func loadAboutUsURL() {
        if let url = URL(string: aboutUSURL) {
            let requestObj = URLRequest(url: url)
            objWebView.navigationDelegate = self
            objWebView.uiDelegate = self
            objWebView.load(requestObj)
        } else {
            // Handle the case where the URL string is invalid or nil
           // print("Invalid URL string: \(PrivacyPolicyURL)")
        }
    }
}
//MARK: IBAction
extension AboutUsVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        KVSpinnerView.dismiss()
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
}
//MARK: WKUIDelegate
extension AboutUsVC : WKUIDelegate, WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KVSpinnerView.dismiss()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KVSpinnerView.show()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        KVSpinnerView.dismiss()
    }
}
