//
//  UpComingTBC.swift
//  TSS
//
//  Created by apple on 13/07/24.
//

import UIKit
protocol UpComingTBCDelegate: AnyObject {
    func cell(_ cell: UpComingTBC, price: String, idx: Int)
    
}
class UpComingTBC: UITableViewCell {
    var index: Int?
    var delegate: UpComingTBCDelegate?
    let inputFormatter = DateFormatter()
    var strPrice: String = ""
    let outputFormatter = DateFormatter()
    var postid: String = ""
    @IBOutlet weak var btnPriceOutlt: GenericButton!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblEventNm: UILabel!
    @IBOutlet weak var lblEventDesc: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "dd MMMM, yyyy"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(withResponse response: upcomingEventResponse?, withIndex index: Int, purchasedEventIds: Set<String>) {
        
        let strTitle = "\(response?.data?[index].title ?? "")"
//        lblEventTitle.text = strTitle.htmlToString()
        lblEventTitle.text = strTitle.decodingHTMLEntities()
        lblEventDesc.text = "\(response?.data?[index].description ?? "")"
        let strDate = "\(response?.data?[index].eventEndDate ?? "")"
        
        if let date = inputFormatter.date(from: strDate) {
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // This will print: 13 September, 2024
            lblEventDate.text = formattedDate
        } else {
            print("Failed to parse the date")
        }
        
        let strBlogUrl = "\(response?.data?[index].thumbnail ?? "")"
        imgEvent.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
       
        let strIspurchased = "\(response?.data?[index].ispurchased ?? "NO")"
        let strEventPrice = "\(response?.data?[index].eventPrice ?? "")"

        
        if strIspurchased == "YES"
        {
            btnPriceOutlt.setTitle("Purchased", for: .normal)
            btnPriceOutlt.isEnabled = false
            btnPriceOutlt.alpha = 0.4
        }
        else
        {
            btnPriceOutlt.setTitle("Price - $ \(strEventPrice)", for: .normal)
            btnPriceOutlt.isEnabled = true
            btnPriceOutlt.alpha = 1.0
        }
    }
    @IBAction func btnPriceTapped(_ sender: Any) {
        delegate?.cell(self, price: strPrice, idx: index!)
    }
    
}
