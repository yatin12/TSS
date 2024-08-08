//
//  FavouriteTBC.swift
//  TSS
//
//  Created by apple on 13/07/24.
//

import UIKit

class FavouriteTBC: UITableViewCell {

    @IBOutlet weak var vwTimeAgo: UIView!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblViewCnt: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFav: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
