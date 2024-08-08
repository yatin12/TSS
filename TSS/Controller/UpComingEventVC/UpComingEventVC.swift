//
//  UpComingEventVC.swift
//  TSS
//
//  Created by apple on 13/07/24.
//

import UIKit

class UpComingEventVC: UIViewController {
    
    var userId: String = ""
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblUpComingEvent: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension UpComingEventVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpHeaderView()

    }

}
//MARK: General Methods
extension UpComingEventVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["UpComingTBC"], withNibNames: ["UpComingTBC"], tbl: tblUpComingEvent)
        tblUpComingEvent.estimatedRowHeight = UITableView.automaticDimension
        tblUpComingEvent.rowHeight = 400
        lblNoData.isHidden = true
        tblUpComingEvent.delegate = self
        tblUpComingEvent.dataSource = self
        tblUpComingEvent.reloadData()
      
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension UpComingEventVC
{
    @IBAction func btnBackTappe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension UpComingEventVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTBC", for: indexPath) as! UpComingTBC
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
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
//MARK: UpComingTBCDelegate
extension UpComingEventVC: UpComingTBCDelegate
{
    func cell(_ cell: UpComingTBC, price: String, idx: Int) {
        print("price==\(price)")
    }
    
    
}
