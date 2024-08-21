//
//  Seaction1CTC.swift
//  TSS
//
//  Created by apple on 13/08/24.
//

import UIKit
import AVKit

class Seaction1CTC: UICollectionViewCell {

//    var player: AVPlayer?
//    var playerLayer: AVPlayerLayer?
    
    var hasVideoPlayed: Bool = false
    
  //  @IBOutlet weak var objPageControl: UIPageControl!
    @IBOutlet weak var objLoader: UIActivityIndicatorView!
    @IBOutlet weak var vwVideo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
/*
    func configure(with videoURL: URL) {
        player = AVPlayer(url: videoURL)
        player?.volume = 0.5
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = vwVideo.bounds
        playerLayer?.videoGravity = .resizeAspect
        vwVideo.layer.addSublayer(playerLayer!)
        
        // Add an observer for when the video finishes
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func videoDidFinish() {
        NotificationCenter.default.post(name: .videoDidFinishPlaying, object: self)
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    */
}
//extension Notification.Name {
//    static let videoDidFinishPlaying = Notification.Name("videoDidFinishPlaying")
//}
