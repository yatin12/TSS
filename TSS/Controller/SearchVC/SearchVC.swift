//
//  SearchVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class SearchVC: UIViewController {
    
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    
}
//MARK: UIViewLife Cycle Methods
extension SearchVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
    }
}
//MARK: General Methods
extension SearchVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)

    }
}
//MARK: IBAction
extension SearchVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
}
