//
//  VideoSec_1TBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit
import AVFoundation
import AVKit

protocol VideoSec_1TBCDelegate: AnyObject {
    func cell(_ cell: VideoSec_1TBC, isWatchListTapped: Bool)
    func cell(_ cell: VideoSec_1TBC, isLikeTapped: Bool, likeAction: String)
    func cell(_ cell: VideoSec_1TBC, shareVideoUrl: String)
    func cell(_ cell: VideoSec_1TBC, isSubscribeBtnTapped: Bool)
    
    
    func pauseVideoBackBtn()
    
}
class VideoSec_1TBC: UITableViewCell {
    private var trailerURL: URL?
    private var fullVideoURL: URL?
    private var isPlayingTrailer = true
    var socialUrl: String = ""
    
    weak var viewController: VideoDetailsVC?
    
    @IBOutlet weak var ConstHeightvideoPlayer: NSLayoutConstraint!
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isVideoFinished = false
    
    
    // @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    
    @IBOutlet weak var imgPlay: UIImageView!
    {
        didSet
        {
            self.imgPlay.isUserInteractionEnabled = true
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnTapPlayPause)))
        }
    }
    @IBOutlet weak var seekSlider: UISlider!
    {
        didSet
        {
            self.seekSlider.addTarget(self, action: #selector(OnTapSlider), for: .valueChanged)
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
    
    @IBOutlet weak var vwWatchListBG: UIView!
    var delegate: VideoSec_1TBCDelegate?
    var isLiked = false
    var strLikeAction: String = "0"
    @IBOutlet weak var vwEvideoContainer: UIView!
    weak var vc: VideoDetailsVC?
    var isSubscribedUser: String = ""
    
    @IBOutlet weak var vwFullScreenBtnControl: UIView!
    @IBOutlet weak var vwPlayBtnControl: UIView!
    @IBOutlet weak var videoBG: UIView!
    @IBOutlet weak var lblCircle: UILabel!
    //  @IBOutlet weak var videoBG: MP4VideoPlayerView!
    @IBOutlet weak var imgEvideos: UIImageView!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    // @IBOutlet weak var objLoader: UIActivityIndicatorView!
    @IBOutlet weak var btnShareOutlt: UIButton!
    @IBOutlet weak var btnWachlistOutlt: UIButton!
    //  @IBOutlet weak var vwVideo: UIView!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var lblLikeCnt: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblPublish: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBlog: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCircle.layer.cornerRadius = lblCircle.frame.size.width / 2
        lblCircle.clipsToBounds = true
        self.setupActivityIndicator()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
    }
    
    func pauseVideoBackBtn() {
        self.videoStop()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        
        lblTitle.text = "\(response?.data?.eVideo?[0].title ?? "")"
        lblDesc.text = "\(response?.data?.eVideo?[0].description ?? "")"
        socialUrl = "\(response?.data?.eVideo?[0].socialURL ?? "")"
         
        if lblDesc.text == ""
        {
            lblDesc.text = "N/A"
        }
        let strDate = "\(response?.data?.eVideo?[0].date ?? "")"
        
        let strWatch = response?.data?.eVideo?[0].isWatch ?? false
        if strWatch == false
        {
            vwWatchListBG.backgroundColor = UIColor(named: "ThemeTextfiledFillColor")
        }
        else
        {
            vwWatchListBG.backgroundColor = UIColor(named: "ThemePinkColor")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        if let pastDate = dateFormatter.date(from: strDate) {
            let strTimeAgo = TimeAgoUtility.timeAgoSinceDate(date: pastDate)
            lblPublish.text = "Published on \(strTimeAgo)"
        }
        
        let strViewCnt =  "\(response?.data?.eVideo?[0].totalViews ?? "")"
        lblViews.text = strViewCnt == "" ? "0 View" : "\(strViewCnt) Views"
        
        let strLikeCnt = "\(response?.data?.eVideo?[0].totalLikes ?? "")"
        lblLikeCnt.text = strLikeCnt == "" ? "0 Like" : "\(strLikeCnt) Likes"
        isLiked = response?.data?.eVideo?[0].isLike ?? false
        
        isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
        
        if strSelectedPostName == "talk_shows"
        {
            vwEvideoContainer.isHidden = true
            videoBG.isHidden = false
            
            if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
            {
                
                /*
                 //Only Play Full video directly
                 
                 if let videoURLString = response?.data?.eVideo?[0].Full_Video_URL,
                 let videoURL = URL(string: videoURLString) {
                 self.prepareVideo(with: videoURL, isFromHome: false)
                 } else {
                 print("Invalid video URL.")
                 }
                 */
                
                //Play Trailer video first its finish then play full video automatically
                if let trailerURLString = response?.data?.eVideo?[0].Trailer_Video_URL,
                   let trailerURL = URL(string: trailerURLString),
                   let fullVideoURLString = response?.data?.eVideo?[0].Full_Video_URL,
                   let fullVideoURL = URL(string: fullVideoURLString) {
                    self.trailerURL = trailerURL
                    self.fullVideoURL = fullVideoURL
                    self.prepareVideo(with: trailerURL, isFromHome: false)
                } else {
                    print("Invalid video URLs.")
                }
                
            }
            else
            {
                if let videoURLString = response?.data?.eVideo?[0].Trailer_Video_URL,
                   let videoURL = URL(string: videoURLString) {
                    self.prepareVideo(with: videoURL, isFromHome: false)
                } else {
                    print("Invalid video URL.")
                    // Handle the case where the URL is nil
                }
            }
        }
        else
        {
            
            if isSubscribedUser == "\(SubscibeUserType.premium)" ||  isSubscribedUser == "\(SubscibeUserType.basic)"
            {
                vwEvideoContainer.isHidden = true
                videoBG.isHidden = false
                
                if let videoURLString = response?.data?.eVideo?[0].Full_Video_URL,
                   let videoURL = URL(string: videoURLString) {
                    self.prepareVideo(with: videoURL, isFromHome: false)
                } else {
                    print("Invalid video URL.")
                    // Handle the case where the URL is nil
                }
            }
            else
            {
                vwEvideoContainer.isHidden = false
                videoBG.isHidden = true
                
                let strBlogUrl = "\(response?.data?.eVideo?[0].thumbnail ?? "")"
                imgEvideos.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
            }
        }
        imgLike.image = isLiked == true ? UIImage(named: "icn_Like") : UIImage(named: "icn_UnLike")
    }
    @IBAction func btnVideoPlayTapped_Evideo(_ sender: Any) {
        
        delegate?.cell(self, isSubscribeBtnTapped: true)
        // AlertUtility.presentSimpleAlert(in: self.vc!, title: "", message: "\(AlertMessages.subscribeMsg)")
        
    }
    @IBAction func btnLikeTapped(_ sender: Any) {
        isLiked.toggle()
        updateLikeButton()
        delegate?.cell(self, isLikeTapped: true, likeAction: strLikeAction)
        
    }
    func updateLikeButton() {
        if isLiked {
            imgLike.image = UIImage(named: "icn_Like")
            strLikeAction = "1"
        } else {
            imgLike.image = UIImage(named: "icn_UnLike")
            strLikeAction = "0"
        }
    }
    @IBAction func btnWatchListTapped(_ sender: Any) {
        delegate?.cell(self, isWatchListTapped: true)
    }
    @IBAction func btnShareTapped(_ sender: Any) {
    
        delegate?.cell(self, shareVideoUrl: socialUrl)
    }
    
    //MARK: - Video Player
    private var timeObserver: Any? = nil
    private var isThumbSeek: Bool = false
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        
        videoBG.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: videoBG.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: videoBG.centerYAnchor)
        ])
    }
    
    func updateLayoutForOrientationChange() {
        let newWidth: CGFloat = (UIScreen.main.bounds.size.width - 46.0) // Desired width
        
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
    
    func videoStop() {
        player?.pause()
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        
        // Unregister this cell when video stops
                if let videoDetailsVC = viewController as? VideoDetailsVC {
                    videoDetailsVC.unregisterPlayingCell(self)
                }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        playerItemStatusObserver?.invalidate()
    }
    func prepareVideo(with url: URL, isFromHome: Bool) {
        let newWidth: CGFloat = (UIScreen.main.bounds.size.width - 46.0)
        
        activityIndicator.startAnimating()
        
        if self.player == nil {
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            
            self.playerLayer?.frame = CGRect(x: self.videoBG.bounds.origin.x, y: self.videoBG.bounds.origin.y, width: newWidth, height: self.videoBG.bounds.size.height)
            
            self.playerLayer?.addSublayer(vwPlayBtnControl.layer)
            
            if let objPlayerLayer = self.playerLayer {
                self.videoBG.layer.addSublayer(objPlayerLayer)
            }
        } else {
            let playerItem = AVPlayerItem(url: url)
            self.player?.replaceCurrentItem(with: playerItem)
        }
        
        // Observe player item status
        playerItemStatusObserver = player?.currentItem?.observe(\.status, options: [.new, .old], changeHandler: { [weak self] (playerItem, change) in
            guard let self = self else { return }
            if playerItem.status == .readyToPlay {
                self.activityIndicator.stopAnimating()
                self.player?.play()
            }
        })
        
        self.setObserverToPlayer()
        
        // Register this cell as playing when video starts
               if let videoDetailsVC = viewController as? VideoDetailsVC {
                   videoDetailsVC.registerPlayingCell(self)
               }
        
        // Add notification observer for when the video finishes playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if isPlayingTrailer && fullVideoURL != nil {
            isPlayingTrailer = false
            prepareVideo(with: fullVideoURL!, isFromHome: false)
        } else {
            isVideoFinished = true
            imgPlay.image = UIImage(named: "icn_play1")
        }
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
    
    @objc private func OnTapPlayPause() {
        if isVideoFinished {
            // If video has finished, start from beginning
            player?.seek(to: CMTime.zero)
            player?.play()
            imgPlay.image = UIImage(named: "icn_pause")
            isVideoFinished = false
        } else if player?.timeControlStatus == .playing {
            imgPlay.image = UIImage(named: "icn_play1")
            player?.pause()
        } else {
            imgPlay.image = UIImage(named: "icn_pause")
            player?.play()
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
}
