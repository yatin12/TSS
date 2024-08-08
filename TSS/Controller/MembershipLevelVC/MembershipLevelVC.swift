//
//  MembershipLevelVC.swift
//  TSS
//
//  Created by apple on 23/07/24.
//

import UIKit

class MembershipLevelVC: UIViewController {
    var userId: String = ""
    @IBOutlet weak var tblMembership: UITableView!
    
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
extension MembershipLevelVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpHeaderView()
        self.registerNib()

    }
  

}
extension MembershipLevelVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["MembershipLevelTBC"], withNibNames: ["MembershipLevelTBC"], tbl: tblMembership)
        tblMembership.estimatedRowHeight = UITableView.automaticDimension
        tblMembership.rowHeight = 381.0
        tblMembership.delegate = self
        tblMembership.dataSource = self
        
    }
}
extension MembershipLevelVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension MembershipLevelVC: UITableViewDelegate, UITableViewDataSource, SubsciberTBCDelegate
{
    func cell(_ cell: SubsciberTBC, idx: Int) {
        
    }
    
    func didTapLearnMore(for cell: SubsciberTBC) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipLevelTBC", for: indexPath) as! MembershipLevelTBC
       
        cell.selectionStyle = .none
        let strFreeContent = "Free Videos, Empowerment, News, TalkShow"
        let arr = strFreeContent.components(separatedBy: ",")
        let cnt = arr.count
        
        cell.configureViews(for: cnt, andIndex: indexPath.row)
        
        
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
