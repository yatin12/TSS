//
//  NotificationTBC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit

class NotificationTBC: UITableViewCell {

    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
