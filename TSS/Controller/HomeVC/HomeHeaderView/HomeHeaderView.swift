//
//  PanelHeaderView.swift
//  Uveaa Solar
//
//  Created by apple on 03/05/24.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblViewAll: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          commonInit()
      }
      
      private func commonInit() {
          loadNib()
      }
      
      private func loadNib() {

          Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)
          addSubview(contentView)
          contentView.frame = self.bounds
          contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      }
}
