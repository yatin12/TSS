//
//  VideoDetailsVC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit
import KVSpinnerView
import AVFoundation

class VideoDetailsVC: UIViewController {
    //  - Variables - 
    
    private var playingVideoCells: Set<VideoSec_1TBC> = []
  //  var isRatingInProgress = false
    
    private let objVideoDetailViewModel = videoDetailViewModel()
    private let objVideoRateViewModel = videoRateViewModel()
    private let objAddWatchListViewModel = AddWatchListViewModel()
    private let objLikeVideoViewModel = LikeVideoViewModel()
    
    var userId: String = ""
    var arrSection = ["","Up Next", "More Videos like this"]
    var objVideoDetailResponse: videoDetailResponse?
    
    var videoId: String = ""
    var strRateVal: String = "0"
    var strComment: String = ""
    var strAction: String = "0"
    
    @IBOutlet weak var vwHeader: UIView!
    //  - Outlets - 
    @IBOutlet weak var tblVideoDetail: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension VideoDetailsVC
{
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.registerNib()
        self.setUpHeaderView()
        self.apiCallGetEvideoDetails()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.restrictRotation = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.restrictRotation = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape == true
        vwHeader.isHidden = isLandscape
        self.tabBarController?.tabBar.isHidden = isLandscape
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateLayoutForOrientationChange()
        }, completion: nil)
    }
    
    private func updateLayoutForOrientationChange() {
        let visibleCells = tblVideoDetail.visibleCells.compactMap { $0 as? VideoSec_1TBC }
        for cell in visibleCells {
            cell.updateLayoutForOrientationChange()
        }
    }
}

//MARK: General Methods
extension VideoDetailsVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func registerNib()
    {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
        
        GenericFunction.registerNibs(for: ["VideoSec_1TBC"], withNibNames: ["VideoSec_1TBC"], tbl: tblVideoDetail)
        GenericFunction.registerNibs(for: ["VideoSec_2TBC"], withNibNames: ["VideoSec_2TBC"], tbl: tblVideoDetail)
        
        GenericFunction.registerNibs(for: ["VideoSec_3TBC"], withNibNames: ["VideoSec_3TBC"], tbl: tblVideoDetail)
        
        tblVideoDetail.estimatedRowHeight = UITableView.automaticDimension
        tblVideoDetail.rowHeight = 737.0
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
}
//MARK: IBAction
extension VideoDetailsVC
{
    // Add cell to tracking
       func registerPlayingCell(_ cell: VideoSec_1TBC) {
           playingVideoCells.insert(cell)
       }
       
       // Remove cell from tracking
       func unregisterPlayingCell(_ cell: VideoSec_1TBC) {
           playingVideoCells.remove(cell)
       }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        pauseVideoBackBtn()
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnSettingTapped(_ sender: Any) {        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        
    }
}
//MARK: UITableViewDataSource & UITableViewDelegate
extension VideoDetailsVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int = 1
        if section == 0
        {
            rowCount = 1
        }
        else if section == 1
        {
            rowCount = objVideoDetailResponse?.data?.eVideo?[0].upNext?.count ?? 0
        }
        else
        {
            rowCount = 1
        }
        return rowCount
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeHeaderView()
        
        headerView.lblCategoryName.text = "\(arrSection[section])"
        
        headerView.lblViewAll.isHidden = true
        
        return headerView
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
        var cell = UITableViewCell()
        if indexPath.section == 0
        {
            let cellToReturn = tableView.dequeueReusableCell(withIdentifier: "VideoSec_1TBC", for: indexPath) as! VideoSec_1TBC
            cellToReturn.selectionStyle = .none
            cellToReturn.vc = self
            cellToReturn.viewController = self
            
            cellToReturn.delegate = self
            cellToReturn.configure(withResponse: objVideoDetailResponse, withIndex: indexPath.row)
            cell = cellToReturn
        }
        else if indexPath.section == 1
        {
            let cellToReturn = tableView.dequeueReusableCell(withIdentifier: "VideoSec_2TBC", for: indexPath) as! VideoSec_2TBC
            cellToReturn.selectionStyle = .none
            cellToReturn.configure(withResponse: objVideoDetailResponse, withIndex: indexPath.row)
            
            cell = cellToReturn
        }
        else
        {
            let cellToReturn = tableView.dequeueReusableCell(withIdentifier: "VideoSec_3TBC", for: indexPath) as! VideoSec_3TBC
            cellToReturn.delegate = self
            
            cellToReturn.selectionStyle = .none
            cellToReturn.configure(withResponse: objVideoDetailResponse, withIndex: indexPath.row)
            
            cell = cellToReturn
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Int = 225
        if indexPath.section == 0
        {
            rowHeight = 540
        }
        else if indexPath.section == 1
        {
            rowHeight = 89
        }
        else
        {
            rowHeight = 737
        }
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2
        {
            videoId = "\(objVideoDetailResponse?.data?.eVideo?[0].moreVideos?[0].id ?? "")"
            self.apiCallGetEvideoDetails()
            let topIndexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
        else if indexPath.section == 1
        {

             videoId = "\(objVideoDetailResponse?.data?.eVideo?[0].upNext?[indexPath.row].id ?? "")"
            self.apiCallGetEvideoDetails()
            let topIndexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }
}
//MARK: VideoSec_3TBCDelegate
extension VideoDetailsVC: VideoSec_3TBCDelegate
{
    func cell(_ cell: VideoSec_3TBC, rateValueNew: Int) {
        print("Received rate value: \(rateValueNew)")
        strRateVal = "\(rateValueNew)"
    }
    func cell(_ cell: VideoSec_3TBC, comment: String, isSubmitBtnTapped: Bool) {
        strComment = comment
        if strRateVal == "0"
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.RateMsg)
        }
        else
        {
            if strComment == "Enter Message"
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.RateMsg1)

            }
            else
            {
                self.apiCallsubmitVideoRate()

            }
        }
        
    }
//    func cell(_ cell: VideoSec_3TBC, rateValue: String) {
//        print("rateValue->\(rateValue)")
//        strRateVal = rateValue
//        
//    }
}
//MARK: VideoSec_1TBCDelegate
extension VideoDetailsVC: VideoSec_1TBCDelegate
{
    func pauseVideoBackBtn() {
        playingVideoCells.forEach { cell in
                   cell.videoStop()
               }
               // Clear the tracking set
               playingVideoCells.removeAll()
        
//        for case let cell as VideoSec_1TBC in tblVideoDetail.visibleCells {
//            cell.videoStop()
//        }
        
    }
    func cell(_ cell: VideoSec_1TBC, shareVideoUrl: String) {
        
        let firstActivityItem = "Share this Blog \n\n"
        
        // Setting url
        let secondActivityItem : NSURL = NSURL(string: shareVideoUrl)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    func cell(_ cell: VideoSec_1TBC, isLikeTapped: Bool, likeAction: String) {
        print("likeAction->\(likeAction)")
        strAction = likeAction
        self.apiCallAddFavouriteList()
    }
    
    
    func cell(_ cell: VideoSec_1TBC, isWatchListTapped: Bool) {
        
        self.apiCallAddWatchList(cell: cell)
    }
    func cell(_ cell: VideoSec_1TBC, isSubscribeBtnTapped: Bool) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: navigationController!, animated: false)

    }
    
}
//MARK: API Call
extension VideoDetailsVC
{
    func apiCallAddFavouriteList()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objLikeVideoViewModel.videoFavUnFav(user_id: userId, video_id: videoId, action: strAction, Type: strSelectedPostName) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    
                    if response.settings?.success == true
                    {
                        self.apiCallGetEvideoDetails()
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
    func apiCallAddWatchList(cell: VideoSec_1TBC)
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objAddWatchListViewModel.addWatchList(user_id: userId, video_id: videoId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    cell.vwWatchListBG.backgroundColor = UIColor(named: "ThemePinkColor")
                    
                    AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")
                    
                    
                case .failure(let error):
                    // Handle failure
                    cell.vwWatchListBG.backgroundColor = UIColor(named: "ThemeTextfiledFillColor")
                    
                    
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
    func apiCallGetEvideoDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objVideoDetailViewModel.VideoDetailApi(userId: userId, videoId: videoId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    
                    if response.settings?.success == true
                    {
                        self.tblVideoDetail.isHidden = false
                        
                        self.objVideoDetailResponse = response
                        self.tblVideoDetail.dataSource = self
                        self.tblVideoDetail.delegate = self
                        self.tblVideoDetail.reloadData()
                        
                        
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
    func apiCallsubmitVideoRate()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objVideoRateViewModel.submitVideoRate(user_id: userId, video_id: videoId, rating: strRateVal, comment: strComment) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    
                    AlertUtility.presentAlert(in: self, title: "", message: "\(response.settings?.message ?? "")", options: "Ok") { option in
                        switch(option) {
                        case 0:
                            self.pauseVideoBackBtn()
                            self.navigationController?.popViewController(animated: true)
                            break
                            
                        default:
                            break
                        }
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
