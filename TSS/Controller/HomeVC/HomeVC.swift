//
//  HomeVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class HomeVC: UIViewController {
    
    var arrSection = ["","Tops News", "Season 1", "Season 1 BTS (Behind the Scenes)", "E.Videos", "Recommended Episodes","Meet The Sisters"]
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension HomeVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.registerNib()
    }
}
//MARK: General Methods
extension HomeVC
{
    func registerNib()
    {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }

        GenericFunction.registerNibs(for: ["HomeTBC"], withNibNames: ["HomeTBC"], tbl: tblHome)
        tblHome.delegate = self
        tblHome.dataSource = self
        tblHome.reloadData()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension HomeVC
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
}
//MARK: UITableViewDataSource & UITableViewDelegate
extension HomeVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeHeaderView()
        
        headerView.lblCategoryName.text = "\(arrSection[section])"
        
        if headerView.lblCategoryName.text == "Season 1 BTS (Behind the Scenes)"
        {
            headerView.lblViewAll.isHidden = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
                headerView.addGestureRecognizer(tapGestureRecognizer)
                headerView.tag = section // Set the tag to identify the section in the tap handler
        }
        else if headerView.lblCategoryName.text == "Meet The Sisters"
        {
            headerView.lblViewAll.isHidden = true
        }
        else
        {
            headerView.lblViewAll.isHidden = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
                headerView.addGestureRecognizer(tapGestureRecognizer)
                headerView.tag = section // Set the tag to identify the section in the tap handler
        }
        
   
            
        
        return headerView
    }
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        if let section = sender.view?.tag {
            print("Header tapped in section \(section)")
            switch section {
            case 1:
                isFromViewAll = true
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsVC", from: navigationController!, animated: true)
                break
            case 2:
                isFromViewAll = true
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                break
            case 3:
                isFromViewAll = true
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                break
            case 4:
                isFromViewAll = true
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                break
            case 5:
                isFromViewAll = true
                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                break
            default:
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: Int = 50
        if section == 0
        {
            sectionHeight = 0
        }
        else
        {
            sectionHeight = 50
        }
        return CGFloat(sectionHeight) // Set the desired height for section headers
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTBC", for: indexPath) as! HomeTBC
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.imgSectionZero.isHidden = false
            cell.objCollectionHome.isHidden = true
            cell.objCollectionMeetSister.isHidden = true
        }
        else if indexPath.section == arrSection.count - 1
        {
            cell.imgSectionZero.isHidden = true
            cell.objCollectionHome.isHidden = true
            cell.objCollectionMeetSister.isHidden = false
        }
        else
        {
            cell.imgSectionZero.isHidden = true
            cell.objCollectionHome.isHidden = false
            cell.objCollectionMeetSister.isHidden = true
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Int = 225
        if indexPath.row == arrSection.count - 1
        {
            rowHeight = 250
        }
        else
        {
            rowHeight = 225
        }
        return CGFloat(rowHeight)
    }
}
