//
//  HomeVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView
import AVFoundation
import AVKit

struct VideoDetailHome {
    let id: String
    let title: String
    let videoURL: URL
    let thumbnail: URL
}
protocol videoCollectionCellDelegate {
    func callBack_videoEnd()
}

class videoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var videoBG : MP4VideoPlayerView!
    
    var delegate: videoCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.videoBG.videoDidEnd = {
            self.delegate?.callBack_videoEnd()
        }
    }
    
}
class MP4VideoPlayerView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    var videoDidEnd: (() -> Void)?
    
    func prepareVideo(with url: URL, isFromHome: Bool) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else { return }
//        playerLayer.videoGravity = .resizeAspect
        if isFromHome == true
        {
            playerLayer.videoGravity = .resizeAspect
        }
        else
        {
            playerLayer.videoGravity = .resizeAspectFill
        }
       

        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        
        // Add observer for video end
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    @objc private func videoDidReachEnd() {
        videoDidEnd?()  // Trigger the callback when the video ends
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }
    
    func unload() {
        NotificationCenter.default.removeObserver(self)  // Remove observer
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
}
class HomeVC: UIViewController {
    //  - Variables - 
 //   let arrVideosLocal = ["trailer-1-final-promo", "trailer-2-final-promo"]
    
   
   // var currentPlayingIndexPath: IndexPath?
    
    
    @IBOutlet weak var objPgControlNew: UIPageControl!
    @IBOutlet weak var objCollNewSeaction1: UICollectionView!
    var objHomeResposne: HomeResposne?
    let objHomeViewModel = HomeViewModel()
    var arrSection: [String] = []
    var userId: String = ""
    var userRole: String = ""
    var isSubscribedUser: String = ""

    var arrVideos: [URL] = []
    var currPage: Int = 0
    
    //  - Outlets - 
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension HomeVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpHeaderView()
        self.setNotificationObserverMethod()
        self.setSectionAccordingUser()
        self.registerNib()
        self.setUpCollectionview()
       // self.setUpCollectionview1()

    
        self.apiCallgetHomeData()
        
    }
}
//MARK: General Methods
extension HomeVC
{
    func setUpCollectionview1()
    {
        
        if let videoPath1 = Bundle.main.path(forResource: "trailer-1-final-promo", ofType: "mp4"),
           let videoPath2 = Bundle.main.path(forResource: "2", ofType: "mp4"),
           let videoPath3 = Bundle.main.path(forResource: "1", ofType: "mp4"),
           let videoPath4 = Bundle.main.path(forResource: "trailer-2-final-promo", ofType: "mp4") {
            arrVideos.append(URL(fileURLWithPath: videoPath1))
            arrVideos.append(URL(fileURLWithPath: videoPath2))
            arrVideos.append(URL(fileURLWithPath: videoPath3))
            arrVideos.append(URL(fileURLWithPath: videoPath4))
        }

        
        objPgControlNew.numberOfPages = self.arrVideos.count

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        self.objCollNewSeaction1.collectionViewLayout = layout
        
        self.objCollNewSeaction1.delegate = self
        self.objCollNewSeaction1.dataSource = self
        self.objCollNewSeaction1.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: 0, section: 0)) as? videoCollectionCell {
                cell.videoBG.play()
            }
        }

    }
    func setUpCollectionview()
    {
        /*
        if let videoPath1 = Bundle.main.path(forResource: "1", ofType: "mp4"),
           let videoPath2 = Bundle.main.path(forResource: "2", ofType: "mp4"),
           let videoPath3 = Bundle.main.path(forResource: "trailer-1-final-promo", ofType: "mp4"),
           let videoPath4 = Bundle.main.path(forResource: "trailer-2-final-promo", ofType: "mp4") {
            arrVideos.append(URL(fileURLWithPath: videoPath1))
            arrVideos.append(URL(fileURLWithPath: videoPath2))
            arrVideos.append(URL(fileURLWithPath: videoPath3))
            arrVideos.append(URL(fileURLWithPath: videoPath4))
        }

        */
        


        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        self.objCollNewSeaction1.collectionViewLayout = layout
        
        /*
        self.objCollNewSeaction1.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: 0, section: 0)) as? videoCollectionCell {
                cell.videoBG.play()
            }
        }
*/
    }
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallHomeTab(notification:)), name: Notification.Name("APIcallforHome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayStop(notification:)), name: Notification.Name("APIcallforVideoStop"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.season1TBS(notification:)), name: Notification.Name("btnWatchNowTapped"), object: nil)
        
    }
    @objc func videoPlayStop(notification: Notification)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Increased delay
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: 0, section: 0)) as? videoCollectionCell {
                cell.videoBG.stop()
            } else {
                print("Cell not found after async dispatch")
            }
        }
    }
    @objc func apicallHomeTab(notification: Notification)
    {
        self.apiCallgetHomeData()
    }
    @objc func season1TBS(notification: Notification)
    {
        isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
        if isSubscribedUser == "\(SubscibeUserType.premium)"
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "Season1TBSVC", from: navigationController!, animated: true)

        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.subscribeForTabMsg)")

        }
        
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
    }
    func setSectionAccordingUser()
    {
        if userRole == USERROLE.SignInUser
        {
            //arrSection = ["","Tops News", "Season 1", "Season 1 BTS (Behind the Scenes)", "E.Videos", "Recommended Episodes","Meet The Sisters"]
            arrSection = ["Tops News", "Season 1", "Season 1 BTS (Behind the Scenes)", "E.Videos", "Recommended Episodes","Meet The Sisters"]

        }
        else
        {
//            arrSection = ["","Tops News", "Recommended Episodes","Meet The Sisters"]
            arrSection = ["Tops News", "Recommended Episodes","Meet The Sisters"]

        }
    }
    func registerNib()
    {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
        
        GenericFunction.registerNibs(for: ["HomeTBC"], withNibNames: ["HomeTBC"], tbl: tblHome)
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
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
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
        if userRole == USERROLE.SignInUser
        {
            if let section = sender.view?.tag {
                print("Header tapped in section \(section)")
                switch section {
                case 0:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsVC", from: navigationController!, animated: true)
                    break
                case 1:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 2:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 3:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                case 4:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                default:
                    break
                }
            }
        }
        else
        {
            if let section = sender.view?.tag {
                print("Header tapped in section \(section)")
                switch section {
                case 0:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsVC", from: navigationController!, animated: true)
                    break
                case 1:
                    isFromViewAll = true
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                case 2:
                    
                    break
                default:
                    break
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: Int = 50
        sectionHeight = 50
        return CGFloat(sectionHeight) // Set the desired height for section headers
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTBC", for: indexPath) as! HomeTBC
        cell.selectionStyle = .none
        
       // cell.objCollectionSection1.isHidden = true
       
        cell.objCollectionHome.isHidden = true
        cell.objCollectionMeetSister.isHidden = true
        cell.objCollection1TBS.isHidden = true
        
        if userRole == USERROLE.SignInUser
        {
            if indexPath.section == 2 {
                cell.objCollection1TBS.isHidden = false
            }
            else if indexPath.section == arrSection.count - 1 {
                cell.objCollectionMeetSister.isHidden = false
            }
            else {
                cell.objCollectionHome.isHidden = false
            }
        }
        else
        {
           //            arrSection = ["","Tops News", "Recommended Episodes","Meet The Sisters"]
            
            if indexPath.section == arrSection.count - 1 {
                cell.objCollectionMeetSister.isHidden = false
            }
            else {
                cell.objCollectionHome.isHidden = false
            }
        }
        
        cell.configure(withResponse: objHomeResposne, withIndex: indexPath.row, strSectionNm: "\(arrSection[indexPath.section])")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Int = 225
        if userRole == USERROLE.SignInUser
        {
            if indexPath.section == arrSection.count - 1
            {
                rowHeight = 250
            }
            else if indexPath.section == 2
            {
                rowHeight = 80
            }
            else
            {
                rowHeight = 225
            }
        }
        else
        {
            if indexPath.section == arrSection.count - 1
            {
                rowHeight = 250
            }
            else
            {
                rowHeight = 225
            }
        }
        return CGFloat(rowHeight)
    }
}


extension HomeVC
{
    func apiCallgetHomeData()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objHomeViewModel.getHomeListData(userId: userId) { result in
                switch result {
                case .success(let response):
                    
                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        
                        if let videoDetails = response.data?.videoDetails {
                            // Define an array to store video URLs
                            //var arrVideos: [URL] = []
                            
                            for video in videoDetails {
                                // Safely unwrap and use video properties
                                if let id = video.id,
                                   let title = video.title,
                                   let videoURLString = video.videourl,
                                   let thumbnailString = video.thumbnail,
                                   let videoURL = URL(string: videoURLString),
                                   let thumbnailURL = URL(string: thumbnailString) {
                                    
                                    // Append video URL to the array
                                    self.arrVideos.append(videoURL)
                                    
                                    // Optionally create a VideoDetailHome instance
                                    _ = VideoDetailHome(id: id, title: title, videoURL: videoURL, thumbnail: thumbnailURL)
                                    // Do something with videoDetail if needed
                                }
                            }
                            
                            // Now arrVideos contains the URLs of all videos
                            print(self.arrVideos)
                            self.objPgControlNew.numberOfPages = self.arrVideos.count
                            
                            self.objCollNewSeaction1.delegate = self
                            self.objCollNewSeaction1.dataSource = self
                            self.objCollNewSeaction1.reloadData()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Increased delay
                                if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: 0, section: 0)) as? videoCollectionCell {
                                    cell.videoBG.play()
                                } else {
                                    print("Cell not found after async dispatch")
                                }
                            }

                            
                        } else {
                            // Handle the case where videoDetails is nil
                            print("No video details available.")
                        }
                       
                        print(response)
                        
                        self.objHomeResposne = response
                        self.tblHome.delegate = self
                        self.tblHome.dataSource = self
                        self.tblHome.reloadData()
                    }
                    else
                    {
                        KVSpinnerView.dismiss()
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


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCollectionCell", for: indexPath) as! videoCollectionCell
        cell.delegate = self
        
        cell.videoBG.prepareVideo(with: self.arrVideos[indexPath.row], isFromHome: true)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           if let videoCell = cell as? videoCollectionCell {
               if indexPath.row == 0 && self.currPage == 0 {
                   videoCell.videoBG.play()
               }
           }
       }
}
//MARK: - videoCollectionCellDelegate
extension HomeVC: videoCollectionCellDelegate {
    func callBack_videoEnd() {
        if self.currPage + 1 < self.arrVideos.count {
            self.objCollNewSeaction1.isPagingEnabled = false
            self.objCollNewSeaction1.scrollToItem(at: IndexPath(item: self.currPage + 1, section: 0), at: .centeredHorizontally, animated: true)
            self.objCollNewSeaction1.isPagingEnabled = true
        }
    }
}
//MARK: - UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page_ = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.objPgControlNew.currentPage = page_
        self.currPage = page_
        
        for i in 0..<self.arrVideos.count {
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: i, section: 0)) as? videoCollectionCell {
                cell.videoBG.stop() // Stop the video in the previous cell
            }
        }
        if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: self.currPage, section: 0)) as? videoCollectionCell {
            cell.videoBG.play() // Play the video in the visible cell
        }
    }
}
