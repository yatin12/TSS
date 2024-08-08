//
//  LiveShowVC.swift
//  TSS
//
//  Created by apple on 20/07/24.
//

import UIKit

class LiveShowVC: UIViewController {
    @IBOutlet weak var tblLiveShow: UITableView!
    
  
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
extension LiveShowVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNodatFound()
        self.setUpHeaderView()
        self.registerNib()
    }
}
//MARk: General Methods
extension LiveShowVC
{
    func setupNodatFound()
    {
        tblLiveShow.isHidden = false
        lblNoDataFound.isHidden = true
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)

    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["SearchTBC"], withNibNames: ["SearchTBC"], tbl: tblLiveShow)
        tblLiveShow.estimatedRowHeight = UITableView.automaticDimension
        tblLiveShow.rowHeight = 275.0
        tblLiveShow.delegate = self
        tblLiveShow.dataSource = self
    }
    
}
//MARk: IBAction
extension LiveShowVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension LiveShowVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTBC", for: indexPath) as! SearchTBC
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
