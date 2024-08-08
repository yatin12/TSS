//
//  VideoSec_3TBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit
import Cosmos
protocol VideoSec_3TBCDelegate: AnyObject {
    func cell(_ cell: VideoSec_3TBC, rateValue: String)
    func cell(_ cell: VideoSec_3TBC, comment: String, isSubmitBtnTapped: Bool)

}
class VideoSec_3TBC: UITableViewCell {
    @IBOutlet weak var lblTimeAgoMoreRelated: UILabel!
    let placeholderText = "Enter Message"
   
    @IBOutlet weak var vwComment: UIView!
    @IBOutlet weak var txtvwComment: UITextView!
    @IBOutlet weak var lblViewsMoreRelated: UILabel!
    @IBOutlet weak var lblTitleMoreRelated: UILabel!
    @IBOutlet weak var imgBlogMoreRelated: UIImageView!
    var delegate: VideoSec_3TBCDelegate?
    
    @IBOutlet weak var vwRate: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwRate.didTouchCosmos = didTouchCosmos
        vwRate.didFinishTouchingCosmos = didFinishTouchingCosmos
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
    private func didTouchCosmos(_ rating: Double) {
        updateRating(requiredRating: rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        
    }
    private func updateRating(requiredRating: Double?) {
        var newRatingValue: Double = 0
        
        if let nonEmptyRequiredRating = requiredRating {
            newRatingValue = nonEmptyRequiredRating
        } else {
        }
        
        let strRatingVal = self.formatValue(newRatingValue)
        //print("strRatingVal-\(strRatingVal)")
        vwRate.rating = newRatingValue
        delegate?.cell(self, rateValue: strRatingVal)
    }
    func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    func configure(withResponse response: videoDetailResponse?, withIndex index: Int) {
        txtvwComment.delegate = self
        let strBlogUrl = "\(response?.data?.eVideo?[0].moreVideos?[0].thumbnail ?? "")"
        imgBlogMoreRelated.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        lblTitleMoreRelated.text = "\(response?.data?.eVideo?[0].moreVideos?[0].title ?? "")"
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //  UserDefaultUtility.saveValueToUserDefaults(value: "YES", forKey: "isUserModified")
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = AppColors.ThemeFontColor
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
            textView.textColor = AppColors.ThemeFontColor
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
            vwComment.layer.borderColor = isEditing ? highlightColor : clearColor
            vwComment.layer.borderWidth = isEditing ? 1.0 : 0.0
        }
    }
}
