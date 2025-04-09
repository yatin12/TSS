//
//  VideoSec_3TBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit
import Cosmos
protocol VideoSec_3TBCDelegate: AnyObject {
//    func cell(_ cell: VideoSec_3TBC, didBeginRating: Bool)
//    func cell(_ cell: VideoSec_3TBC, didFinishRating: Bool)
//    
//    func cell(_ cell: VideoSec_3TBC, rateValue: String)
    func cell(_ cell: VideoSec_3TBC, comment: String, isSubmitBtnTapped: Bool)
    func cell(_ cell: VideoSec_3TBC, rateValueNew: Int)

}
class VideoSec_3TBC: UITableViewCell {
    @IBOutlet weak var lblTimeAgoMoreRelated: UILabel!
    let placeholderText = "Enter Message"
    var currentRating: Int = 0
    
   // var lastContentOffset: CGPoint = .zero
//    var initialContentOffset: CGPoint?
//    weak var tableView: UITableView?
//       private var isRatingInProgress = false
    @IBOutlet weak var btnRate1: UIButton!
    @IBOutlet weak var btnRate2: UIButton!
    @IBOutlet weak var btnRate3: UIButton!
    @IBOutlet weak var btnRate4: UIButton!
    @IBOutlet weak var btnRate5: UIButton!

    @IBOutlet weak var imgStar5: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var vwRateMine: UIView!
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var vwComment: UIView!
    @IBOutlet weak var txtvwComment: UITextView!
    @IBOutlet weak var lblViewsMoreRelated: UILabel!
    @IBOutlet weak var lblTitleMoreRelated: UILabel!
    @IBOutlet weak var imgBlogMoreRelated: UIImageView!
    var delegate: VideoSec_3TBCDelegate?
    @IBOutlet weak var vwRate: CosmosView!

    
    @IBAction func btnRateTapped(_ sender: UIButton) {
        switch sender {
          case btnRate1:
            currentRating = 1
          case btnRate2:
            currentRating = 2
          case btnRate3:
            currentRating = 3
          case btnRate4:
            currentRating = 4
          case btnRate5:
            currentRating = 5
          default:
            currentRating = 0
          }
        updateStarImages(for: currentRating)
        delegate?.cell(self, rateValueNew: currentRating)
    }
    func updateStarImages(for rating: Int) {
        let starImages = [imgStar1, imgStar2, imgStar3, imgStar4, imgStar5]
        let filledStarImage = UIImage(named: "icn_starFilled")
        let emptyStarImage = UIImage(named: "icn_star")
        
        for (index, starImage) in starImages.enumerated() {
            if index < rating {
                starImage?.image = filledStarImage
            } else {
                starImage?.image = emptyStarImage
            }
        }
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblCircle.layer.cornerRadius = lblCircle.frame.size.width / 2
        lblCircle.clipsToBounds = true
      
        
        self.setupTextView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupTextView()
    {
        txtvwComment.text = placeholderText
        txtvwComment.textColor = UIColor.lightGray
    }
   
    func formatValue(_ value: Double) -> String {
        return String(format: "%.0f", value)
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        txtvwComment.delegate = self
        let strBlogUrl = "\(response?.data?.eVideo?[0].moreVideos?[0].thumbnail ?? "")"
        imgBlogMoreRelated.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        lblTitleMoreRelated.text = "\(response?.data?.eVideo?[0].moreVideos?[0].title ?? "")"
        //self.tableView = self.findParentTableView()
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        delegate?.cell(self, comment: txtvwComment.text ?? "", isSubmitBtnTapped: true)
    }
}
//MARK: UITextViewDelegate
extension VideoSec_3TBC: UITextViewDelegate
{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.textColor = AppColors.ThemeFontColor
            textView.textColor = UIColor(named: "ThemeFontColor")

            
            textView.text = text
        }
        
        
        else {
            return true
        }
        
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateBorderTextView(for: textView, isEditing: true)
        
        if textView.text == placeholderText {
            textView.text = ""
           // textView.textColor = AppColors.ThemeFontColor
            textView.textColor = UIColor(named: "ThemeFontColor")

        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateBorderTextView(for: textView, isEditing: false)
        
        if textView.text.isEmpty && textView.text != placeholderText {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    private func updateBorderTextView(for textview: UITextView, isEditing: Bool) {
        
        
        if textview == txtvwComment {
            vwComment.layer.borderColor = isEditing ? highlightColor : DefaultBorderColor
            //vwComment.layer.borderWidth = isEditing ? 1.0 : 0.0
        }
    }
}
