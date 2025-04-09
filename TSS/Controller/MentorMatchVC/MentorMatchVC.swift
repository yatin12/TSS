//
//  MentorMatchVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 02/12/24.
//

import UIKit

class MentorMatchVC: UIViewController {

    
    @IBOutlet weak var constHeaderHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeaderHeight)
    }
}
//MARK: IBAction
extension MentorMatchVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
}
