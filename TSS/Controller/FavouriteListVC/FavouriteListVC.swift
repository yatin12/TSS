//
//  FavouriteListVC.swift
//  TSS
//
//  Created by apple on 13/07/24.
//

import UIKit
import KVSpinnerView

class FavouriteListVC: UIViewController {
    var userId: String = ""
    var strSelectedSegment: String = "Favourite"
    private let objFavouriteListViewModel = FavouriteListViewModel()
    private let objWatchListViewModel = watchListViewModel()
    var objFavouriteResponse: favouriteResponse?
    var objWatchListResponse: watchListResponse?
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var objSegment: WMSegment!
    @IBOutlet weak var tblFavourite: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    
}
//MARK: UIViewLife Cycle Methods
extension FavouriteListVC
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpHeaderView()
        self.setUpSegmentControl()
        self.apiCallFavouriteList()
    }
}
//MARK: General Methods
extension FavouriteListVC
{
    func setUpSegmentControl()
    {
        objSegment.selectorType = .bottomBar
        objSegment.bottomBarHeight = 3.0
        objSegment.SelectedFont = UIFont(name: AppFontName.Poppins_SemiBold.rawValue, size: 16)!
        objSegment.normalFont = UIFont(name: AppFontName.Poppins_SemiBold.rawValue, size: 16)!
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        
        lblHeader.text = strSelectedSegment
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["FavouriteTBC"], withNibNames: ["FavouriteTBC"], tbl: tblFavourite)
        tblFavourite.estimatedRowHeight = UITableView.automaticDimension
        tblFavourite.rowHeight = 317.0
        lblNoData.isHidden = true
        tblFavourite.delegate = self
        tblFavourite.dataSource = self
        tblFavourite.reloadData()
      
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension FavouriteListVC
{
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        switch sender.selectedSegmentIndex {
        case 0:
            strSelectedSegment = "Favourite"
            lblHeader.text = strSelectedSegment
            tblFavourite.reloadData()
            self.apiCallFavouriteList()
            break
        case 1:
            strSelectedSegment = "WatchList"
            lblHeader.text = strSelectedSegment
            tblFavourite.reloadData()
            self.apiCallWatchList()
            break
            
        default:
            print("default item")
        }
    }
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
extension FavouriteListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCnt: Int = 0
        if strSelectedSegment == "Favourite"
        {
            rowCnt = objFavouriteResponse?.data?.videosLiked?.count ?? 0
        }
        else
        {
            rowCnt = objWatchListResponse?.data?.count ?? 0
        }
        return rowCnt
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTBC", for: indexPath) as! FavouriteTBC
        cell.selectionStyle = .none
        if strSelectedSegment == "Favourite"
        {
            cell.lblTimeAgo.isHidden = true
            
            cell.lblTitle.text = "\(objFavouriteResponse?.data?.videosLiked?[indexPath.row].title ?? "")"
            
            let strBlogUrl = "\(objFavouriteResponse?.data?.videosLiked?[indexPath.row].thumbnail ?? "")"
            cell.imgFav.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
         
          
        }
        else
        {
            cell.lblTitle.text = "\(objWatchListResponse?.data?[indexPath.row].title ?? "")"
            let strBlogUrl = "\(objWatchListResponse?.data?[indexPath.row].thumbnail ?? "")"
            cell.imgFav.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
         
          //  let strViewCnt = "\(response?.data?.eVideo?[0].upNext?[index].totalViews ?? "")"
           // cell.lblViewCnt.text = strViewCnt == "" ? "0 View" : "\(strViewCnt) Views"
            
            let strDate = "\(objWatchListResponse?.data?[indexPath.row].date ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormate
            if let pastDate = dateFormatter.date(from: strDate) {
                let strTimeAgo = TimeAgoUtility.timeAgoSinceDate(date: pastDate)
                cell.lblTimeAgo.text = "\(strTimeAgo)"
            }
            
            cell.lblTimeAgo.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if strSelectedSegment == "Favourite"
        {
            let videoId = "\(objFavouriteResponse?.data?.videosLiked?[indexPath.row].id ?? "0")"
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(videoId)")

        }
        else
        {
            let videoId = "\(objWatchListResponse?.data?[indexPath.row].id ?? "0")"
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(videoId)")
        }
    }
}
//MARK: API Call
extension FavouriteListVC
{
    func apiCallFavouriteList()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objFavouriteListViewModel.favouriteList(userId: userId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                   
                    if response.settings?.success == true
                    {
                        if response.data?.videosLiked?.count ?? 0 > 0
                        {
                            self.tblFavourite.isHidden = false
                            self.lblNoData.isHidden = true
                            
                           self.objFavouriteResponse = response
                            self.tblFavourite.dataSource = self
                            self.tblFavourite.delegate = self
                            self.tblFavourite.reloadData()
                        }
                        else
                        {
                            self.tblFavourite.isHidden = true
                            self.lblNoData.isHidden = false
                        }
                        
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                        
                    }
                }
            }
        }
        else
        {
            KVSpinnerView.dismiss()
             AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
    func apiCallWatchList()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objWatchListViewModel.watchList(userId: userId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                   
                    if response.settings?.success == true
                    {
                        if response.data?.count ?? 0 > 0
                        {
                            self.tblFavourite.isHidden = false
                            self.lblNoData.isHidden = true
                            
                            self.objWatchListResponse = response
                            self.tblFavourite.dataSource = self
                            self.tblFavourite.delegate = self
                            self.tblFavourite.reloadData()
                        }
                        else
                        {
                            self.tblFavourite.isHidden = true
                            self.lblNoData.isHidden = false
                        }
                        
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                        
                    }
                }
            }
        }
        else
        {
            KVSpinnerView.dismiss()
             AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
}

