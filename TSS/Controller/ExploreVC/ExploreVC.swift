//
//  ExploreVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 29/11/24.
//

import UIKit
import WebKit
import GoogleMobileAds

class ExploreVC: UIViewController {
    
    @IBOutlet weak var constHeightBannervw: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    var userRole: String = ""
    @IBOutlet weak var constHeaderHeight: NSLayoutConstraint!
}
extension ExploreVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()

        self.loadBannerView()
    }
}
extension ExploreVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeaderHeight)
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
    }
    
    func loadBannerView()
    {
        if userRole == USERROLE.SignInUser
        {
            let isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
            if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
            {
                constHeightBannervw.constant = 0
            }
            else
            {
                constHeightBannervw.constant = 50
                if currentEnvironment == .production
                {
                    bannerView.adUnitID = LiveAdmobId

                }
                else
                {
                    bannerView.adUnitID = testAdmobId

                }
                // bannerView.rootViewController = self
                bannerView.delegate = self
                 bannerView.load(GADRequest())
            }
        }
        else
        {
            constHeightBannervw.constant = 50
        }
    }
}
//MARK: IBAction
extension ExploreVC
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
    @IBAction func btnMentorMatchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "MentorMatchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnEvideoTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            isFromViewAll = true
            strSelectedPostName = "evideos"
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnVirtualEventTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "UpComingEventVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnFoundationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "FoundationsVC", from: navigationController!, animated: true)

    }
}
//MARK: - GADBannerViewDelegate
extension ExploreVC: GADBannerViewDelegate
{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
