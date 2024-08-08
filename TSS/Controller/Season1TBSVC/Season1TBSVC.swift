//
//  Season1TBSVC.swift
//  TSS
//
//  Created by apple on 07/08/24.
//

import UIKit
import WebKit
import KVSpinnerView

class Season1TBSVC: UIViewController {

    @IBOutlet weak var objWebView: WKWebView!
    @IBAction func btnBackTapped(_ sender: Any) {
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
extension Season1TBSVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func loadSeason1TBSURL() {
        if let url = URL(string: Season1TBSURL) {
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
//MARK: UIWebViewDelegate
extension Season1TBSVC : WKUIDelegate, UIWebViewDelegate,WKNavigationDelegate
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
