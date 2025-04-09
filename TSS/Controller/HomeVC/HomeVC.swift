import UIKit
import KVSpinnerView
import AVFoundation
import AVKit
import GoogleMobileAds

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
    var currentTime: CMTime?
    private var isVideoFinished = false
    
    
    weak var viewController: HomeVC?
    @IBOutlet weak var lblCurrentTime: UILabel!
    private var timeObserver: Any? = nil
    private var isThumbSeek: Bool = false
    var videoDidEnd: (() -> Void)?
    var indexPathNew: IndexPath? // Add this property
    
    
    @IBOutlet weak var ConstHeightvideoPlayer: NSLayoutConstraint!
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white // You can change this color as needed
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @objc private func OnTapSlider()
    {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
    
    @objc private func OnToggleScreen() {
        
        guard let viewController = viewController else { return }
        if #available(iOS 16.0, *) {
            guard let windowScene = viewController.view.window?.windowScene else { return }
            if windowScene.interfaceOrientation == .portrait {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    if error != nil {
                        print(error.localizedDescription)
                    }
                }
            } else {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    if  error != nil {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            } else {
                let orientation = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            }
        }
    }
    @objc private func OnTapPlayPause()
    {
        if isVideoFinished {
            // Video has ended, start from beginning
            player?.seek(to: CMTime.zero)
            player?.play()
            imgPlay.image = UIImage(named: "icn_pause")
            isVideoFinished = false
        } else if self.player?.timeControlStatus == .playing {
            self.imgPlay.image = UIImage(named: "icn_play1")
            self.player?.pause()
        } else {
            self.imgPlay.image = UIImage(named: "icn_pause")
            self.player?.play()
        }
    }
    @objc private func OnTapPlayPause1()
    {
        if self.player?.timeControlStatus == .playing
        {
            self.imgPlay.image = UIImage(named: "icn_play1")
            
            self.player?.pause()
        }
        else
        {
            self.imgPlay.image = UIImage(named: "icn_pause")
            self.player?.play()
        }
    }
    
    @IBOutlet weak var imgFullScreenToggle: UIImageView!
    {
        didSet
        {
            self.imgFullScreenToggle.isUserInteractionEnabled = true
            self.imgFullScreenToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnToggleScreen)))
        }
    }
    @IBOutlet weak var seekSlider: UISlider!
    {
        didSet
        {
            self.seekSlider.addTarget(self, action: #selector(OnTapSlider), for: .valueChanged)
        }
    }
    @IBOutlet weak var imgPlay: UIImageView!
    {
        didSet
        {
            self.imgPlay.isUserInteractionEnabled = true
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnTapPlayPause)))
        }
    }
    
    var player: AVPlayer?
    @IBOutlet weak var vwPlayBtnControl: UIView!
    var playerLayer: AVPlayerLayer?
    @IBOutlet weak var videoBG: UIView!
    
    var delegate: videoCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
        self.videoDidEnd = {
            self.delegate?.callBack_videoEnd()
            
            self.isVideoFinished = true
            self.imgPlay.image = UIImage(named: "icn_play1")
        }
    }
    
    private func setupActivityIndicator() {
        videoBG.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: videoBG.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: videoBG.centerYAnchor)
        ])
    }
    func prepareVideo(with url: URL, isFromHome: Bool) {
        let newWidth: CGFloat = (UIScreen.main.bounds.size.width ) // Desired width
        let playerItem = AVPlayerItem(url: url)
        
        activityIndicator.startAnimating()
        
        
        if self.player == nil {
            player = AVPlayer(playerItem: playerItem)
            //self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidReachEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
            
            
            // Ensure videoBG is properly set up
            self.videoBG.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.videoBG)
            
            // Set up playerLayer
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.videoBG.bounds.size.height)
            self.videoBG.layer.addSublayer(self.playerLayer!)
            
            // Set up vwPlayBtnControl
            self.vwPlayBtnControl.translatesAutoresizingMaskIntoConstraints = false
            self.videoBG.addSubview(self.vwPlayBtnControl)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidReachEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerItemReadyToPlay),
                name: .AVPlayerItemNewAccessLogEntry,
                object: playerItem
            )
        }
        
        self.setObserverToPlayer()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func playerItemReadyToPlay() {
        // Stop the activity indicator when the video is ready to play
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.player?.play()
        }
    }
    @objc private func videoDidReachEnd() {
        // videoDidEnd?()  // Trigger the callback when the video ends
        
        videoDidEnd?()
        isVideoFinished = true
        imgPlay.image = UIImage(named: "icn_play1")
    }
    private func setObserverToPlayer()
    {
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    private func updatePlayerTime() {
        guard let player = self.player,
              let currentItem = player.currentItem else {
            self.lblCurrentTime.text = "00:00:00 / 00:00:00"
            return
        }
        
        let duration = currentItem.duration
        guard duration.isValid && !duration.isIndefinite else {
            self.lblCurrentTime.text = "00:00:00 / 00:00:00"
            return
        }
        
        let currentTime = player.currentTime()
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if durationInSeconds > 0 && !self.isThumbSeek {
            self.seekSlider.value = Float(currentTimeInSeconds / durationInSeconds)
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        let formatTime: (Double) -> String = { seconds in
            return formatter.string(from: seconds) ?? "00:00:00"
        }
        
        let sliderValue = max(0, min(Double(self.seekSlider.value), 1))
        let currentValueInSeconds = sliderValue * durationInSeconds
        
        let currentTimeFormatted = formatTime(currentValueInSeconds)
        let totalTimeFormatted = formatTime(durationInSeconds)
        
        self.lblCurrentTime.text = "\(currentTimeFormatted) / \(totalTimeFormatted)"
    }
    private func updatePlayerTime1()
    {
        guard let currentTime = self.player?.currentTime() else { return }
        
        guard let duration = self.player?.currentItem?.duration else {return}
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isThumbSeek == false
        {
            self.seekSlider.value = Float(currentTimeInSecond / durationTimeInSecond)
        }
        
        
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        
        var hours = value / 3600
        var mins =  (value / 60).truncatingRemainder(dividingBy: 60)
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        let strCurreTime = "\(hoursStr):\(minsStr):\(secsStr)"
        
        hours = durationTimeInSecond / 3600
        mins = (durationTimeInSecond / 60).truncatingRemainder(dividingBy: 60)
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        let strTotalTime = "\(hoursStr):\(minsStr):\(secsStr)"
        self.lblCurrentTime.text = "\(strCurreTime) / \(strTotalTime)"
        
    }
    func stop() {
        print("Stopping video at index: \(indexPathNew?.row ?? -1)")
        
        player?.pause()
        player?.seek(to: CMTime.zero)
        
        //        player?.pause()
        //        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }
    func play(fromTime: CMTime? = nil) {
        if let time = fromTime ?? currentTime {
            player?.seek(to: time)
        }
        player?.play()
    }
    
    
    func pause() {
        currentTime = player?.currentTime() // Store current time when pausing
        
        player?.pause()
    }
    func updateLayoutForOrientationChange() {
        let newWidth: CGFloat = UIScreen.main.bounds.size.width
        guard let windowInterface = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        
        if windowInterface.isPortrait {
            self.ConstHeightvideoPlayer.constant = 247
        } else {
            self.ConstHeightvideoPlayer.constant = UIScreen.main.bounds.size.height // Adjust the height for landscape
        }
        
        DispatchQueue.main.async {
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.videoBG.bounds.height)
            self.videoBG.layoutIfNeeded()
            self.playerLayer?.layoutIfNeeded()
        }
        
        if let player = self.player {
            currentTime = player.currentTime()
        }
        
        
        /*
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         self.playerLayer?.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.videoBG.bounds.height)
         }
         */
    }
    func updateLayoutForOrientationChange1() {
        let newWidth: CGFloat = (UIScreen.main.bounds.size.width ) // Desired width
        
        guard let windowInterface = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        
        if windowInterface.isPortrait {
            self.ConstHeightvideoPlayer.constant = 247
        } else {
            self.ConstHeightvideoPlayer.constant = self.videoBG.bounds.width
            
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playerLayer?.frame = CGRect(x: self.videoBG.bounds.origin.x, y: self.videoBG.bounds.origin.y, width: newWidth, height: self.videoBG.bounds.height)
        }
    }
}
class HomeVC: UIViewController {
    //  - Variables - 
    private var currentlyVisibleIndexPath: IndexPath?
    private var videoCurrentTimes: [Int: CMTime] = [:]
    
    @IBOutlet weak var constHeightBannervw: NSLayoutConstraint!
    
    @IBOutlet weak var constTopTblHome: NSLayoutConstraint!
    @IBOutlet weak var vwHeader: UIView!
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
    private var isActive = false
    
    //  - Outlets - 
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLife Cycle Methods
extension HomeVC
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()

        self.loadBannerView()
        self.setUpHeaderView()
        self.setNotificationObserverMethod()
        self.setSectionAccordingUser()
        self.registerNib()
        self.setUpCollectionview()
        
        self.apiCallgetHomeData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.restrictRotation = true
        self.tabBarController?.tabBar.isHidden = false
        updateCollectionViewLayout()
        
        // Play the video for the current page
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playVideoForCurrentPage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.restrictRotation = false
        stopAllVideos()
    }
    func stopAllVideos() {
        for cell in self.objCollNewSeaction1.visibleCells {
            if let videoCell = cell as? videoCollectionCell {
                videoCell.stop()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isActive = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isActive = false
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard isActive else { return }
        
        let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape == true
        vwHeader.isHidden = isLandscape
        self.tabBarController?.tabBar.isHidden = isLandscape
        constTopTblHome.constant = isLandscape ? 40 : 0
        let currentPage = self.currPage
        if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? videoCollectionCell,
           let currentTime = cell.player?.currentTime() {
            videoCurrentTimes[currentPage] = currentTime
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            if let layout = self.objCollNewSeaction1.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.invalidateLayout()
            }
            self.objCollNewSeaction1.visibleCells.compactMap { $0 as? videoCollectionCell }
                .forEach { $0.updateLayoutForOrientationChange() }
            self.objCollNewSeaction1.layoutIfNeeded()
            
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            let pageWidth = self.objCollNewSeaction1.frame.width
            let newOffset = CGPoint(x: CGFloat(currentPage) * pageWidth, y: 0)
            self.objCollNewSeaction1.setContentOffset(newOffset, animated: false)
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? videoCollectionCell {
                cell.updateLayoutForOrientationChange()
                let storedTime = self.videoCurrentTimes[currentPage]
                self.playVideoForCurrentPage(fromTime: storedTime)
            }
        })
    }
    func playVideoForCurrentPage(fromTime: CMTime? = nil) {
        for i in 0..<self.arrVideos.count {
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: i, section: 0)) as? videoCollectionCell {
                if i == self.currPage {
                    // Only play if the video is not already playing
                    if cell.player?.timeControlStatus != .playing {
                        cell.play(fromTime: fromTime)
                    }
                } else {
                    cell.pause() // Pause instead of stop to preserve current time
                }
            }
        }
    }
    func playVideoForCurrentPage1(fromTime: CMTime? = nil) {
        for i in 0..<self.arrVideos.count {
            if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: i, section: 0)) as? videoCollectionCell {
                if i == self.currPage {
                    cell.play(fromTime: fromTime)
                } else {
                    cell.stop()
                }
            }
        }
    }
    
    
    private func updateCollectionViewLayout() {
        guard let layout = objCollNewSeaction1.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let newWidth: CGFloat = UIScreen.main.bounds.size.width
        
        if UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape == true {
            // Set item size to occupy the full width of the screen in landscape mode
            let newWidth: CGFloat = UIScreen.main.bounds.size.width - 116.0
            layout.itemSize = CGSize(width: newWidth, height: objCollNewSeaction1.bounds.size.height)
        } else {
            // Set item size for portrait mode
            layout.itemSize = CGSize(width: newWidth, height: objCollNewSeaction1.bounds.size.height)
        }
        
        let visibleCells = objCollNewSeaction1.visibleCells.compactMap { $0 as? videoCollectionCell }
        for cell in visibleCells {
            cell.updateLayoutForOrientationChange()
        }
        
        layout.invalidateLayout() // Invalidate layout to apply changes
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isPortrait = UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat
        let width = collectionView.bounds.width
        let height: CGFloat = isPortrait ? 247 : collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: General Methods
extension HomeVC
{
    
    func setUpCollectionview()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 247)
        self.objCollNewSeaction1.collectionViewLayout = layout
    }
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallHomeTab(notification:)), name: Notification.Name("APIcallforHome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayStop(notification:)), name: Notification.Name("APIcallforVideoStop"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.season1TBS(notification:)), name: Notification.Name("btnWatchNowTapped"), object: nil)
        
    }
    @objc func videoPlayStop(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for cell in self.objCollNewSeaction1.visibleCells {
                if let videoCell = cell as? videoCollectionCell {
                    videoCell.stop()
                }
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
        if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "Season1TBSVC", from: navigationController!, animated: true)
        }
        else
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: navigationController!, animated: false)
            
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
            arrSection = ["Tops News", "Season 1", "Season 1 BTS (Behind the Scenes)", "E.Videos", "Recommended Episodes","Meet The Sisters"]
            
        }
        else
        {
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
    func loadBannerView()
    {
        if userRole == USERROLE.SignInUser
        {
            let isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
            if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
            {
                constHeightBannervw.constant = 0
            }
            else
            {
                constHeightBannervw.constant = 50
                if currentEnvironment == .production
                {
                    bannerView.adUnitID = LiveAdmobId

                }
                else
                {
                    bannerView.adUnitID = testAdmobId

                }
                // bannerView.rootViewController = self
                bannerView.delegate = self
                 bannerView.load(GADRequest())
            }
        }
        else
        {
            constHeightBannervw.constant = 50
        }
    }
    
}
//MARK: - GADBannerViewDelegate
extension HomeVC: GADBannerViewDelegate
{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        print("Your device ID for AdMob testing: \(GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers ?? [])")

    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
//MARK: - IBAction
extension HomeVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
        stopAllVideos()
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        stopAllVideos()
        
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
        
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
        stopAllVideos()
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
        
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
extension HomeVC: UITableViewDataSource, UITableViewDelegate, HomeTBCDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Only handle scroll events for the collection view
        guard scrollView == objCollNewSeaction1 else { return }

        playVideoForCurrentPage()
    }
    func cell(_ cell: HomeTBC, id: String, strSectionName: String, MeetSisterUrl: String) {
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
        
        
        if strSectionName == "Tops News"
        {
            if userRole == USERROLE.SignInUser
            {
                strSlectedBlogCatNews = ""
                NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsDeatilsVC", from: navigationController!, data: "\(id)")
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
           
        }
        else if strSectionName == "Season 1"
        {
            if userRole == USERROLE.SignInUser
            {
                strSelectedPostName = "talk_shows"
                
                NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(id)")
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            
        }
        else if strSectionName == "E.Videos"
        {
            if userRole == USERROLE.SignInUser
            {
                strSelectedPostName = "evideos"
                
                NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(id)")
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            
        }
        else if strSectionName == "Recommended Episodes"
        {
            if userRole == USERROLE.SignInUser
            {
                strSelectedPostName = "talk_shows"
                
                NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(id)")
            }
            else
            {
                AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
            }
            
           
        }
        else if strSectionName == "Meet The Sisters"
        {
            
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "MeetSisterPageVC", from: navigationController!, data: "\(MeetSisterUrl)")
        }
    }
    
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
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
        
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
                    strSelectedPostName = "talk_shows"
                    
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 2:
                    isFromViewAll = true
                    
                    strSelectedPostName = "talk_shows"
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                case 3:
                    isFromViewAll = true
                    strSelectedPostName = "evideos"
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                    break
                case 4:
                    isFromViewAll = true
                    strSelectedPostName = "talk_shows"
                    
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
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
                    strSelectedPostName = "talk_shows"
                    
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "TalkShowVC", from: navigationController!, animated: true)
                    break
                    
//                    isFromViewAll = true
//                    strSelectedPostName = "evideos"
//                    
//                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "EVideoVC", from: navigationController!, animated: true)
                   
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
        cell.delegate = self
        
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
                //Meet The sisters
                rowHeight = 250
            }
            else if indexPath.section == 2
            {
                rowHeight = 80
            }
            else
            {
//                rowHeight = 225
                rowHeight = 265
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
                        //Khushbu_Change
                        if let videoDetails = response.data?.videoDetails {
                            // Define an array to store video URLs
                            //var arrVideos: [URL] = []
                            self.arrVideos = []
                            
                            for video in videoDetails {
                                
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
                            
                            
                            /*
                             self.arrVideos.append(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
                             
                             self.arrVideos.append(URL(string: "https://test.fha.nqn.mybluehostin.me/wp-content/uploads/2024/07/trailer-1-final-promo.mp4")!)
                             
                             */
                            // Now arrVideos contains the URLs of all videos
                            print(self.arrVideos)
                            self.objPgControlNew.numberOfPages = self.arrVideos.count
                            
                            self.objCollNewSeaction1.delegate = self
                            self.objCollNewSeaction1.dataSource = self
                            self.objCollNewSeaction1.reloadData()
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Increased delay
                                if let cell = self.objCollNewSeaction1.cellForItem(at: IndexPath(row: 0, section: 0)) as? videoCollectionCell {
                                    // cell.videoBG.play()
                                    cell.play()
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
        cell.indexPathNew = currentlyVisibleIndexPath
        cell.viewController = self
        cell.prepareVideo(with: self.arrVideos[indexPath.row], isFromHome: true)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? videoCollectionCell {
            if indexPath.row == 0 && self.currPage == 0 {
                videoCell.play()
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
        // Only handle scroll events for the collection view
        guard scrollView == objCollNewSeaction1 else { return }
        
        let pageWidth = scrollView.frame.size.width
        let page_ = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.objPgControlNew.currentPage = page_
        
        // Only update currPage and play video if the page has actually changed
        if self.currPage != page_ {
            self.currPage = page_
            playVideoForCurrentPage()
        }
    }
}
/*
 extension HomeVC: UIScrollViewDelegate {
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 let pageWidth = scrollView.frame.size.width
 let page_ = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
 self.objPgControlNew.currentPage = page_
 self.currPage = page_
 
 playVideoForCurrentPage()
 }
 }
 */
