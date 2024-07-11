//
//  VideoSec_1TBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit
protocol VideoSec_1TBCDelegate: AnyObject {
    func cell(_ cell: VideoSec_1TBC, isWatchListTapped: Bool)

}
class VideoSec_1TBC: UITableViewCell {

    var delegate: VideoSec_1TBCDelegate?
    @IBAction func btnWatchListTapped(_ sender: Any) {
        delegate?.cell(self, isWatchListTapped: true)
    }
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnShareOutlt: UIButton!
    @IBOutlet weak var btnWachlistOutlt: UIButton!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var lblLikeCnt: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblPublish: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBlog: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        
        let strBlogUrl = "\(response?.data?.eVideo?[0].thumbnail ?? "")"
        imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        
        lblTitle.text = "\(response?.data?.eVideo?[0].title ?? "")"
        lblDesc.text = "\(response?.data?.eVideo?[0].description ?? "")"
     //   lblPublish.text = "\(response?.data?.eVideo?[0].description ?? "")"
        lblViews.text =  "\(response?.data?.eVideo?[0].totalViews ?? "0")"
        let strLikeCnt = "\(response?.data?.eVideo?[0].totalLikes ?? " ")"
        if strLikeCnt == ""
        {
            lblLikeCnt.text = "0 Likes"
        }
        else{
            lblLikeCnt.text = "\(strLikeCnt) Likes"
        }
       
    }
    
}
