//
//  FoundationsVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 29/11/24.
//

import UIKit
import WebKit
import KVSpinnerView

class FoundationsVC: UIViewController {

    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    @IBOutlet weak var objWebview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.loadFoundationURL()
    }
}
//MARK: General Methods
extension FoundationsVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func loadFoundationURL() {
        if let url = URL(string: foundationURL) {
            let requestObj = URLRequest(url: url)
            objWebview.navigationDelegate = self
            objWebview.uiDelegate = self
            objWebview.load(requestObj)
        } else {
            // Handle the case where the URL string is invalid or nil
           // print("Invalid URL string: \(PrivacyPolicyURL)")
        }
    }
}
//MARK: IBAction
extension FoundationsVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        KVSpinnerView.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
    }
}
//MARK: WKUIDelegate
extension FoundationsVC : WKUIDelegate, WKNavigationDelegate
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
