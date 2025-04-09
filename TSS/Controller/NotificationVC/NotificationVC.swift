//
//  NotificationVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class NotificationVC: UIViewController {
    //  - Variables - 
    
    //  - Outlets - 
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension NotificationVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.setupNodatFound()
      //  self.registerNib()
    }
}
//MARK: General Methods
extension NotificationVC
{
    func setupNodatFound()
    {
        tblNotification.isHidden = true
        lblNoDataFound.isHidden = false
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)

    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["NotificationTBC"], withNibNames: ["NotificationTBC"], tbl: tblNotification)
        tblNotification.estimatedRowHeight = UITableView.automaticDimension
        tblNotification.rowHeight = 90.0
        tblNotification.delegate = self
        tblNotification.dataSource = self
        tblNotification.reloadData()
    }
    
}
//MARK: IBAction
extension NotificationVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension NotificationVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTBC", for: indexPath) as! NotificationTBC
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
