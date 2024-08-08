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
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblEventNm: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPriceTapped(_ sender: Any) {
        delegate?.cell(self, price: "", idx: index!)
    }
    
}
