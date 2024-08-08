//
//  HomeCollectionCell.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgBlog: UIImageView!
    
    @IBOutlet weak var btnWatchNowOutlt: GenericButton!
    @IBOutlet weak var vwRestHeader: UIView!
    @IBOutlet weak var vwSeason1TBS: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
