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
        func pauseVideoBackBtn()

    }
    class VideoSec_1TBC: UITableViewCell {
        var player: AVPlayer?
        var playerLayer: AVPlayerLayer?
        var delegate: VideoSec_1TBCDelegate?
        var isLiked = false
        var strLikeAction: String = "0"
        @IBOutlet weak var vwEvideoContainer: UIView!
        weak var vc: VideoDetailsVC?
        var isSubscribedUser: String = ""
        
        @IBOutlet weak var imgEvideos: UIImageView!
        @IBOutlet weak var imgLike: UIImageView!
        @IBOutlet weak var lblDesc: UILabel!
        @IBOutlet weak var objLoader: UIActivityIndicatorView!
        @IBOutlet weak var btnShareOutlt: UIButton!
        @IBOutlet weak var btnWachlistOutlt: UIButton!
        @IBOutlet weak var vwVideo: UIView!
        @IBOutlet weak var btnLikeOutlet: UIButton!
        @IBOutlet weak var lblLikeCnt: UILabel!
        @IBOutlet weak var lblViews: UILabel!
        @IBOutlet weak var lblPublish: UILabel!
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var imgBlog: UIImageView!
        
        override func awakeFromNib() {
            super.awakeFromNib()
    //        self.setUpLoader()
    //        self.initializePlayer()
            self.setNotificationObserver()
        
            
        }
        func pauseVideoBackBtn() {
                player?.pause()
                playerLayer?.removeFromSuperlayer()
                playerLayer = nil
                objLoader.isHidden = false
                objLoader.startAnimating()
            }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
            self.setUpLoader()
            self.initializePlayer()
            
            lblTitle.text = "\(response?.data?.eVideo?[0].title ?? "")"
            lblDesc.text = "\(response?.data?.eVideo?[0].description ?? "")"
            let strDate = "\(response?.data?.eVideo?[0].date ?? "")"

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
                vwVideo.isHidden = false
                
                if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
                {
                    self.playVideo(strVideo: response?.data?.eVideo?[0].Full_Video_URL ?? "")

                }
                else
                {
                    self.playVideo(strVideo: response?.data?.eVideo?[0].Trailer_Video_URL ?? "")

                }

            }
            else
            {
               
                if isSubscribedUser == "\(SubscibeUserType.premium)" ||  isSubscribedUser == "\(SubscibeUserType.basic)"
                {
                    vwEvideoContainer.isHidden = true
                    vwVideo.isHidden = false
                    
                    self.playVideo(strVideo: response?.data?.eVideo?[0].Full_Video_URL ?? "")
                }
                else
                {
                    vwEvideoContainer.isHidden = false
                    vwVideo.isHidden = true
                    
                     let strBlogUrl = "\(response?.data?.eVideo?[0].thumbnail ?? "")"
                     imgEvideos.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                }


            }
            imgLike.image = isLiked == true ? UIImage(named: "icn_Like") : UIImage(named: "icn_UnLike")
           
        }
        @IBAction func btnVideoPlayTapped_Evideo(_ sender: Any) {
            AlertUtility.presentSimpleAlert(in: self.vc!, title: "", message: "\(AlertMessages.subscribeMsg)")

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
        func setUpLoader()
        {
            self.objLoader.isHidden = false
            objLoader.startAnimating()
        }
        func initializePlayer()
        {
            playerLayer = AVPlayerLayer()
        }
        func setNotificationObserver()
        {
            NotificationCenter.default.removeObserver(self)
            
            // foreground event
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reinitializePlayerLayer),
                name: UIApplication.willEnterForegroundNotification,
                object: nil)
            
            // add these 2 notifications to prevent freeze on long Home button press and back
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(setPlayerLayerToNil),
                name: UIApplication.willResignActiveNotification,
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reinitializePlayerLayer),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)
        }
        
        /*
        func playVideo(strVideo: String!) {
            let sess = AVAudioSession.sharedInstance()
            guard let formattedUrl = strVideo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            if let videoURL = URL(string: formattedUrl) {
                player = AVPlayer(url: videoURL)
                playerLayer = AVPlayerLayer(player: player)
                
                // Show the loader while the video is loading
                self.objLoader.isHidden = false
                self.objLoader.startAnimating()
                
                // Set the player's automatic wait tolerance (reduced buffering)
                player?.currentItem?.preferredForwardBufferDuration = 5.0
                player?.automaticallyWaitsToMinimizeStalling = false
                
                // Observe the player's status to start playback once enough data is buffered
                player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
                player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new], context: nil)
                
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                
                playerLayer?.frame = CGRect(x: 0, y: 0, width: (screenWidth - 46.0), height: 227)
                playerLayer?.videoGravity = .resizeAspect
                playerLayer?.shouldRasterize = true
                playerLayer?.rasterizationScale = UIScreen.main.scale
                
                self.vwVideo.layer.addSublayer(playerLayer!)
                self.vwVideo.bringSubviewToFront(objLoader)
                
                if sess.isOtherAudioPlaying {
                    _ = try! sess.setCategory(.playback, mode: .default, options: .mixWithOthers)
                    _ = try? sess.setActive(true)
                } else {
                    try? sess.setCategory(.playback, options: .mixWithOthers)
                    try? sess.setActive(true)
                }
                
                UIApplication.shared.beginReceivingRemoteControlEvents()
                player?.actionAtItemEnd = .none
                
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerItemDidReachEnd),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem)
            }
        }

        // Observe the player's status and start playback when enough data is buffered
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "status", let playerItem = object as? AVPlayerItem {
                if playerItem.status == .readyToPlay {
                    // Check if enough data is buffered
                    if let timeRange = player?.currentItem?.loadedTimeRanges.first?.timeRangeValue {
                        let bufferedTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                        let currentTime = CMTimeGetSeconds(player!.currentTime())
                        
                        // Start playback if enough data is buffered
                        if bufferedTime - currentTime > 2.0 { // Start when at least 2 seconds are buffered
                            self.objLoader.isHidden = true
                            self.objLoader.stopAnimating()
                            player?.play()
                        }
                    }
                } else if playerItem.status == .failed {
                    // Handle error
                    print("Failed to load video")
                    self.objLoader.isHidden = true
                    self.objLoader.stopAnimating()
                }
            } else if keyPath == "loadedTimeRanges" {
                // Check buffered time again when new data is loaded
                if let timeRange = player?.currentItem?.loadedTimeRanges.first?.timeRangeValue {
                    let bufferedTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                    let currentTime = CMTimeGetSeconds(player!.currentTime())
                    
                    if bufferedTime - currentTime > 2.0 { // Start when at least 2 seconds are buffered
                        self.objLoader.isHidden = true
                        self.objLoader.stopAnimating()
                        player?.play()
                    }
                }
            }
        }

        */

        
    
        func playVideo(strVideo: String!) {
            let sess = AVAudioSession.sharedInstance()
            guard let formattedUrl = strVideo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            if let videoURL = URL(string: formattedUrl) {
                player = AVPlayer(url: videoURL)
                playerLayer = AVPlayerLayer(player: player)
                
                // Show the loader while the video is loading
                self.objLoader.isHidden = false
                self.objLoader.startAnimating()
                
                // Observe the player's status to hide the loader and start playback once the video is ready
                player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
                
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                
                playerLayer?.frame = CGRect(x: 0, y: 0, width: (screenWidth - 46.0), height: 227)
                playerLayer?.videoGravity = .resizeAspect
                playerLayer?.shouldRasterize = true
                playerLayer?.rasterizationScale = UIScreen.main.scale
                
                self.vwVideo.layer.addSublayer(playerLayer!)
                self.vwVideo.bringSubviewToFront(objLoader)
                
                if sess.isOtherAudioPlaying {
                    _ = try! sess.setCategory(.playback, mode: .default, options: .mixWithOthers)
                    _ = try? sess.setActive(true)
                } else {
                    try? sess.setCategory(.playback, options: .mixWithOthers)
                    try? sess.setActive(true)
                }
                
                UIApplication.shared.beginReceivingRemoteControlEvents()
                player?.actionAtItemEnd = .none
                
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerItemDidReachEnd),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem)
            }
        }

        // Observe the player's status and start playback when ready
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "status", let playerItem = object as? AVPlayerItem {
                if playerItem.status == .readyToPlay {
                    // Hide the loader when the video is ready to play
                    self.objLoader.isHidden = true
                    self.objLoader.stopAnimating()
                    
                    // Start playing the video
                    player?.play()
                } else if playerItem.status == .failed {
                    // Handle error
                    print("Failed to load video")
                    self.objLoader.isHidden = true
                    self.objLoader.stopAnimating()
                }
            }
        }
        
      
        /*
        func playVideo(strVideo: String!)
        {
          
            let sess = AVAudioSession.sharedInstance()
            guard let formattedUrl = strVideo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            if let videoURL = URL(string: formattedUrl) {
                
                player = AVPlayer(url: videoURL)
                playerLayer = AVPlayerLayer(player: player)
                player?.playImmediately(atRate: 1.0)
                
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                
                playerLayer?.frame = CGRect(x: 0, y: 0, width: (screenWidth - 46.0), height: 227)

                playerLayer?.videoGravity = .resizeAspect
                
              //  playerLayer?.videoGravity = .resizeAspectFill

               
                playerLayer?.shouldRasterize = true
                playerLayer?.rasterizationScale = UIScreen.main.scale
                
                self.objLoader.isHidden = false
                self.vwVideo.layer.addSublayer(playerLayer!)
                self.vwVideo.bringSubviewToFront(objLoader)
               // if player?.timeControlStatus.rawValue == 2
                //{
                    self.objLoader.isHidden = true
                    self.objLoader.stopAnimating()
                    self.objLoader.sendSubviewToBack(self)
               // }
                
                if sess.isOtherAudioPlaying {
                    // print("go inside")
                    // _ = try? sess.setCategory(.playback, with: .mixWithOthers)
                    _=try! sess.setCategory(.playback, mode: .default ,options: .mixWithOthers)
                    _ = try? sess.setActive(true)
                }
                else {
                    try? sess.setCategory(.playback, options: .mixWithOthers)
                    try? sess.setActive(true)
                }
                UIApplication.shared.beginReceivingRemoteControlEvents()
                player?.play()
                player?.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playerItemDidReachEnd),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem)
            }
        }
        */
        func pauseVideo() {
//            player?.pause()
//            playerLayer = nil
            
            player?.pause()  // Pause the player
                playerLayer?.removeFromSuperlayer()  // Remove the player layer from the view
                playerLayer = nil  // Reset the player layer
                objLoader.isHidden = true  // Show the loader
                objLoader.stopAnimating()
        }
    }
    //MARK: NSNotificationCenter Methods
    extension VideoSec_1TBC: AVAudioPlayerDelegate
    {
        
        @objc func playerItemDidReachEnd(_ notification: Notification) {
            if isSubscribedUser == "YES"
            {
                let playerItem = notification.object as? AVPlayerItem
                playerItem?.seek(to: CMTime.zero)
            }
            else
            {
                let playerItem = notification.object as? AVPlayerItem
                   playerItem?.seek(to: CMTime.zero, completionHandler: { _ in
                      
                       self.pauseVideo()
                       AlertUtility.presentSimpleAlert(in: self.vc!, title: "", message: "\(AlertMessages.subscribeMsg)")
                   })
            }
          
            
        }
        
        @objc fileprivate func playerItemReachedEnd(){
            // this works like a rewind button. It starts the player over from the beginning
            player?.seek(to: CMTime.zero)
        }
        
        // background event
        @objc fileprivate func setPlayerLayerToNil(){
            // first pause the player before setting the playerLayer to nil. The pause works similar to a stop button
            pauseVideoBackBtn()
            player?.pause()
            playerLayer = nil
        }
        
        // foreground event
        @objc fileprivate func reinitializePlayerLayer()
        {
            if let player = player {
                       playerLayer = AVPlayerLayer(player: player)
                       playerLayer?.frame = vwVideo.bounds
                       playerLayer?.videoGravity = .resizeAspect
                       vwVideo.layer.addSublayer(playerLayer!)
                   }
        }
        
        /*{
            
            if let player1 = player{
                
                // player1 = AVPlayerLayer(player: player)
                
                playerLayer = AVPlayerLayer(player: player)
                
                if #available(iOS 10.0, *) {
                    if player1.timeControlStatus == .paused{
                        player1.play()
                    }
                } else {
                    //                    if player.isPlaying == false{
                    //                        player.play()
                    //                    }
                    
                    if (player1.rate != 0 && player1.error == nil) {
                       // print("playing")
                    }
                    else
                    {
                        player1.play()
                    }
                    
                }
            }
        }
        */
    }
