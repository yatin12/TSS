//
//  NewsTBC.swift
//  TSS
//
//  Created by apple on 01/07/24.
//

import UIKit
import SDWebImage

class NewsTBC: UITableViewCell {

  //  var objBlogByCategoryViewModel: blogByCategoryViewModel!
    @IBOutlet weak var lblBlogCategoryNm: UILabel!
    @IBOutlet weak var imgBlog: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAuthorNm: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "MMMM dd, yyyy"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(withResponse response: blogByCategoryResponse?, withIndex index: Int) {
        let strTitle = "\(response?.data?[index].title ?? "")"
//        lblTitle.text = strTitle.htmlToString()
        lblTitle.text = strTitle.decodingHTMLEntities()

        
        lblDesc.text = "\(response?.data?[index].description ?? "")"
        if lblDesc.text == ""
        {
            lblDesc.text = "N/A"
        }
        
     let dateString = "\(response?.data?[index].date ?? "")"
        
        if let date = inputFormatter.date(from: dateString) {
            // Create another DateFormatter to format the Date object
          
            
            // Convert the Date object to the formatted string
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // Output: November 26, 2024
            lblDate.text  = formattedDate
        } else {
            print("Invalid date string")
            lblDate.text = "-"
        }
        
        lblAuthorNm.text = "\(response?.data?[index].author ?? "")"
        let strBlogUrl = "\(response?.data?[index].thumbnail ?? "")"
        imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
//        lblBlogCategoryNm.text = strSelectedBlog.htmlToString()
        lblBlogCategoryNm.text = strSelectedBlog.decodingHTMLEntities()

        
    }
}
