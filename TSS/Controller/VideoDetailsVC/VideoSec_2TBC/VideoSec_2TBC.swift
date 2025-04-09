//
//  VideoSec_2TBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit

class VideoSec_2TBC: UITableViewCell {
    
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblViewsCnt: UILabel!
    @IBOutlet weak var lblUpNextTitle: UILabel!
    @IBOutlet weak var lblDot: UILabel!
    @IBOutlet weak var imgUpNextBlog: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDot.layer.cornerRadius = lblDot.frame.size.width / 2
        lblDot.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        let strBlogUrl = "\(response?.data?.eVideo?[0].upNext?[index].thumbnail ?? "")"
        imgUpNextBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        
        lblUpNextTitle.text = "\(response?.data?.eVideo?[0].upNext?[index].title ?? "")"
        let strViewCnt = "\(response?.data?.eVideo?[0].upNext?[index].totalViews ?? "")"
        lblViewsCnt.text = strViewCnt == "" ? "0 View" : "\(strViewCnt) Views"
        
        let strDate = "\(response?.data?.eVideo?[0].upNext?[index].date ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        if let pastDate = dateFormatter.date(from: strDate) {
            let strTimeAgo = TimeAgoUtility.timeAgoSinceDate(date: pastDate)
            lblTimeAgo.text = "\(strTimeAgo)"
        }
    }
}
