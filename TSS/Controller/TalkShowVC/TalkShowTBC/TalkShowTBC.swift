//
//  TalkShowTBC.swift
//  TSS
//
//  Created by apple on 02/07/24.
//

import UIKit

class TalkShowTBC: UITableViewCell {

    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
