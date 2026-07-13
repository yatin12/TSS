//
//  MentorMatchVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 02/12/24.
//

import UIKit

class MentorMatchVC: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var constHeaderHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.setHeaderTitle()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeaderHeight)
    }
    func setHeaderTitle()
    {
        let title = UserDefaults.standard.string(forKey: "MentorMatchHeaderTitle") ?? "Mentor Match"
        lblHeaderTitle.text = title
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
