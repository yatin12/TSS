//
//  SettingTBC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class SettingTBC: UITableViewCell {
    @IBOutlet weak var imgNext: UIImageView!
    
  
    @IBOutlet weak var swtNotificationOutlt: UISwitch!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        swtNotificationOutlt.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
