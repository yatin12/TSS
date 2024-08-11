//
//  PodCastVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import WebKit
import KVSpinnerView

class PodCastVC: UIViewController {
    var isSubscribedUser: String = ""

    var userRole: String = ""
    @IBOutlet weak var objWebView: WKWebView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLifeCycle Methods
extension PodCastVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.setNotificationObserverMethod()
        self.checkSubscribeUserOrnot()
    }

}
//MARK: General Methods
extension PodCastVC
{
    func checkSubscribeUserOrnot()
    {
        self.loadPodcastURL()
        /*
        isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
        if isSubscribedUser != "\(SubscibeUserType.free)"
        {
            self.loadPodcastURL()
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.subscribeForTabMsg)")

        }
        */
    }
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallPodcastTab(notification:)), name: Notification.Name("APIcall_PodCast"), object: nil)
    }
    @objc func apicallPodcastTab(notification: Notification)
    {
        self.checkSubscribeUserOrnot()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
    }
    func loadPodcastURL() {
        if let url = URL(string: PodCastURL) {
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
//MARk: IBAction
extension PodCastVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }

}
//MARK: UIWebViewDelegate
extension PodCastVC : WKUIDelegate, UIWebViewDelegate,WKNavigationDelegate
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
