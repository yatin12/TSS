//
//  PrivacyPolicyVC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit
import WebKit
import KVSpinnerView

class PrivacyPolicyVC: UIViewController {
    //  - Variables - 
    @IBOutlet weak var objWebView: WKWebView!

    //  - Outlets - 
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    @IBOutlet weak var vwNotification: UIView!
    
}
extension PrivacyPolicyVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.loadPrivacyPolicyURL()
        self.setUpHeadreViewHideShow()
    }
}
//MARK: General Methods
extension PrivacyPolicyVC
{
    func setUpHeadreViewHideShow()
    {
        if isFromPrivacyViewSetting == true
        {
            vwSearch.isHidden = false
            vwNotification.isHidden = false
        }
        else
        {
            vwSearch.isHidden = true
            vwNotification.isHidden = true
        }
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func loadPrivacyPolicyURL() {
        if let url = URL(string: PrivacyPolicyURL) {
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
extension PrivacyPolicyVC
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
extension PrivacyPolicyVC : WKUIDelegate, WKNavigationDelegate
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
