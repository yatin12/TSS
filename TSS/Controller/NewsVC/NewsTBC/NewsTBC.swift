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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(withResponse response: blogByCategoryResponse?, withIndex index: Int) {
        let strTitle = "\(response?.data?[index].title ?? "")"
        lblTitle.text = strTitle.htmlToString()
        lblDesc.text = "\(response?.data?[index].description ?? "")"
        lblDate.text = "\(response?.data?[index].date ?? "")"
        lblAuthorNm.text = "\(response?.data?[index].author ?? "")"
        let strBlogUrl = "\(response?.data?[index].thumbnail ?? "")"
        imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        lblBlogCategoryNm.text = strSelectedBlog.htmlToString()

    }
}
