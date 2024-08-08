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

}
class VideoSec_1TBC: UITableViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var delegate: VideoSec_1TBCDelegate?
    var isLiked = false
    var strLikeAction: String = "0"
    
   
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
        self.setUpLoader()
        self.initializePlayer()
        self.setNotificationObserver()
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        
        
        
       // let strBlogUrl = "\(response?.data?.eVideo?[0].thumbnail ?? "")"
        //imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        
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
        
        if strSelectedPostName == "talk_shows"
        {
            self.playVideo(strVideo: response?.data?.eVideo?[0].Trailer_Video_URL ?? "")

        }
        else
        {
            self.playVideo(strVideo: response?.data?.eVideo?[0].Full_Video_URL ?? "")

        }
        imgLike.image = isLiked == true ? UIImage(named: "icn_Like") : UIImage(named: "icn_UnLike")
       
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
    func playVideo(strVideo: String!)
    {
      
        let sess = AVAudioSession.sharedInstance()
        
        //let strvid = "https://www.youtube.com/watch?v=9xwazD5SyVg"
      //  let strvid = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
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
    func pauseVideo() {
        player?.pause()
        playerLayer = nil
    }
}
//MARK: NSNotificationCenter Methods
extension VideoSec_1TBC: AVAudioPlayerDelegate
{
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        //play Video Again
        let player = notification.object as? AVPlayerItem
        player?.seek(to: CMTime.zero)
    }
    @objc fileprivate func playerItemReachedEnd(){
        // this works like a rewind button. It starts the player over from the beginning
        player?.seek(to: CMTime.zero)
    }
    
    // background event
    @objc fileprivate func setPlayerLayerToNil(){
        // first pause the player before setting the playerLayer to nil. The pause works similar to a stop button
        player?.pause()
        playerLayer = nil
    }
    
    // foreground event
    @objc fileprivate func reinitializePlayerLayer(){
        
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
}
