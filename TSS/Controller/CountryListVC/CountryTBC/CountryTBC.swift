//
//  CountryTBC.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import UIKit

class CountryTBC: UITableViewCell {
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
