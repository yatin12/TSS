//
//  SubsciberTBC.swift
//  TSS
//
//  Created by apple on 20/07/24.
//

import UIKit
protocol SubsciberTBCDelegate: AnyObject {
    func didTapLearnMore(for cell: SubsciberTBC)
    func cell(_ cell: SubsciberTBC, idx: Int)

}
class SubsciberTBC: UITableViewCell {
    
    weak var delegate: SubsciberTBCDelegate?

    var idx: Int = 0
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblDesc: TappableLabel!
    @IBOutlet weak var vwActive: UIView!
    @IBOutlet weak var vwChoosePlan: UIView!
    
    @IBOutlet weak var lblChoosePlan: UILabel!
    @IBOutlet weak var lbl10: UILabel!
    @IBOutlet weak var lbl9: UILabel!
    @IBOutlet weak var lbl8: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var vw10: UIView!
    @IBOutlet weak var vw9: UIView!
    @IBOutlet weak var vw8: UIView!
    @IBOutlet weak var vw7: UIView!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureViews(for count: Int, withResponse response: membershipPlanResponse?, andIndex idx: Int, planType strPlanType: String) {
        let views = [vw1, vw2, vw3, vw4, vw5, vw6, vw7, vw8, vw9, vw10]
        for (index, view) in views.enumerated() {
            view?.isHidden = index >= count
        }
        
        
        let strPlanName = "\(response?.data?[idx].name ?? "Free")"
        lblPlanName.text = strPlanName
        let isActive = response?.data?[idx].isActive ?? false
        vwActive.isHidden = isActive == true ? false : true
        
        
        if strPlanName == "Free" {
            let attributedString = NSMutableAttributedString(string: "Free", attributes: boldAttributes)
            attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
            attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
            lblPrice.attributedText = attributedString
            
        }
        else
        {
            let strPlanPrice = "\(response?.data?[idx].billingAmount ?? "0.00")"
            
            let attributedString = NSMutableAttributedString(string: "$\(strPlanPrice)", attributes: boldAttributes)
            attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
            attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
            lblPrice.attributedText = attributedString
            
        }
        
        let strDesc = "\(response?.data?[idx].description ?? "Free")"
        //lblDesc.text = strDesc.prefix(50) + " Learn More"
        
        let strTemp =  strDesc.prefix(50)
        let attributedStringDesc = NSMutableAttributedString(string: "\(strTemp)", attributes: semiBoldAttributes)
        attributedStringDesc.append(NSAttributedString(string: " ", attributes: semiBoldAttributes))
        attributedStringDesc.append(NSAttributedString(string: " Learn More", attributes: boldSubscribeAttributes))
        lblDesc.attributedText = attributedStringDesc
        
        
//        lblDesc.onTap = { [weak self] range, text in
//               if text == " Learn More" {
//                   self?.delegate?.didTapLearnMore(for: self!)
//               }
//           }
//        
        layoutIfNeeded()
    }
    @IBAction func btnChoosePlanTapped(_ sender: Any) {
        delegate?.cell(self, idx: idx)
    }
    @IBAction func btnLearnMoreTapped(_ sender: Any) {
        self.delegate?.didTapLearnMore(for: self)
        layoutIfNeeded()
    }
}
