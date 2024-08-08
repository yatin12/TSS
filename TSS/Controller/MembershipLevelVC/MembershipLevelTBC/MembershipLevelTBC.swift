//
//  MembershipLevelTBC.swift
//  TSS
//
//  Created by apple on 23/07/24.
//

import UIKit

class MembershipLevelTBC: UITableViewCell {

    @IBAction func btnSubmitTapped(_ sender: Any) {
    }
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl8: UILabel!
    @IBOutlet weak var lbl9: UILabel!
    @IBOutlet weak var lbl10: UILabel!


    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var vw7: UIView!
    @IBOutlet weak var vw8: UIView!
    @IBOutlet weak var vw9: UIView!
    @IBOutlet weak var vw10: UIView!




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureViews(for count: Int, andIndex idx: Int) {
        let views = [vw1, vw2, vw3, vw4, vw5, vw6, vw7, vw8, vw9, vw10]
        for (index, view) in views.enumerated() {
            view?.isHidden = index >= count
        }
    }
}
