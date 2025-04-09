//
//  MeetSisterPageVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 31/08/24.
//

import UIKit
import WebKit
import KVSpinnerView

class MeetSisterPageVC: UIViewController {
    var strSisterUrl: String = ""
    @IBOutlet weak var objWebView: WKWebView!
    @IBAction func btnBackTapped(_ sender: Any) {
        KVSpinnerView.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpHeaderView()
        self.loadSeason1TBSURL()
    }
}
//MARK: General Methods
extension MeetSisterPageVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func loadSeason1TBSURL() {
        if let url = URL(string: strSisterUrl) {
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
//MARK: WKUIDelegate
extension MeetSisterPageVC : WKUIDelegate, WKNavigationDelegate
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
