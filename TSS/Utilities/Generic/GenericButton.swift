//
//  GenericButton.swift
//  Uveaa Solar
//
//  Created by apple on 12/01/24.
//

import UIKit

class GenericButton: UIButton {

    var borderwidth: CGFloat = 0
    var bordercolor = UIColor.clear.cgColor
   // var cornerRadius = 0
    	
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = bordercolor
        self.layer.borderWidth = borderwidth
        
        self.setTitleColor(UIColor.white,for: .normal)
        self.titleLabel?.font = UIFont(name: AppFontName.Poppins_Bold.rawValue, size: 16)
        
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor(named: "ThemePinkColor")
    }

    func customStyle() {
        guard let customFont = UIFont(name: AppFontName.Poppins_Bold.rawValue, size: 16) else {return}
        self.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        customStyle()
       }

}
