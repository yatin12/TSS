//
//  MembershipLevelNewTBC.swift
//  TSS
//
//  Created by khushbu bhavsar on 22/09/24.
//

import UIKit
protocol MembershipLevelNewTBCDelegate: AnyObject {
    func cell(_ cell: MembershipLevelNewTBC, idx: Int)
    
}
class MembershipLevelNewTBC: UITableViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanNm: UILabel!
    @IBOutlet weak var spaceView1: UIView!
    @IBOutlet weak var spaceView2: UIView!
    @IBOutlet weak var spaceView3: UIView!
    @IBOutlet weak var spaceView4: UIView!
    @IBOutlet weak var spaceView5: UIView!
    @IBOutlet weak var spaceView6: UIView!
    @IBOutlet weak var spaceView7: UIView!
    @IBOutlet weak var spaceView8: UIView!
    @IBOutlet weak var spaceView9: UIView!
    @IBOutlet weak var spaceView10: UIView!

    
    @IBOutlet weak var lbl1New: UILabel!
    @IBOutlet weak var lbl2New: UILabel!
    @IBOutlet weak var lbl3New: UILabel!
    @IBOutlet weak var lbl4New: UILabel!
    @IBOutlet weak var lbl5New: UILabel!
    @IBOutlet weak var lbl6New: UILabel!
    @IBOutlet weak var lbl7New: UILabel!
    @IBOutlet weak var lbl8New: UILabel!
    @IBOutlet weak var lbl9New: UILabel!
    @IBOutlet weak var lbl10New: UILabel!
    private var imageViews: [UIImageView] = []
   
    weak var delegate: MembershipLevelNewTBCDelegate?
    var idx: Int = 0
    var strPrice: String = ""
    var strPlanNm: String = ""
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        delegate?.cell(self, idx: idx)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createImageViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func createImageViews() {
        let labels = [lbl1New, lbl2New, lbl3New, lbl4New, lbl5New, lbl6New, lbl7New, lbl8New, lbl9New, lbl10New]
        
        for label in labels {
            guard let label = label else { continue }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
           // imageView.image = UIImage(named: "icn_Tick_Subscriber")
           // imageView.backgroundColor = UIColor.black
            imageView.backgroundColor =  UIColor(named: "SUbscriptionDotColor")
            imageView.cornerRadius = 3.0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isHidden = true // Initially hide all image views
            
            contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8), // Position to the left of the label
                imageView.centerYAnchor.constraint(equalTo: label.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalToConstant: 6),
                imageView.heightAnchor.constraint(equalToConstant: 6)
            ])
            
            imageViews.append(imageView)
        }
    }
    func configureViews(for count: Int, withResponse response: membershipPlanResponse?, andIndex idx: Int, arrFreeContent: [String]) {
       
        lblPlanNm.text = "You have selected the \(strPlanNm) Plan  membership level."
        lblPrice.text = "The price for membership is \(strPrice) now."
        let labels = [lbl1New, lbl2New, lbl3New, lbl4New, lbl5New, lbl6New, lbl7New, lbl8New, lbl9New, lbl10New]
        let spaceViews = [spaceView1, spaceView2, spaceView3, spaceView4, spaceView5, spaceView6, spaceView7, spaceView8, spaceView9, spaceView10]

        for (index, label) in labels.enumerated() {
            let isHidden = index >= count
            label?.isHidden = isHidden
            spaceViews[index]?.isHidden = isHidden
            
            if index < imageViews.count {
                imageViews[index].isHidden = isHidden
            }

            if index < arrFreeContent.count {
                label?.text = arrFreeContent[index].trimmingCharacters(in: .whitespaces)
            }
        }
        
        layoutIfNeeded()
    }
    
}
