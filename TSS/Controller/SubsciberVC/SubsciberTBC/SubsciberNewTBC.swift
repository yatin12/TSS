//
//  SubsciberNewTBC.swift
//  TSS
//
//  Created by khushbu bhavsar on 21/09/24.
//

import UIKit
import SwiftyStoreKit
protocol SubsciberNewTBCDelegate: AnyObject {
    func cell(_ cell: SubsciberNewTBC, idx: Int, planName: String)
    
}
class SubsciberNewTBC: UITableViewCell {
    weak var delegate: SubsciberNewTBCDelegate?
    var idx: Int = 0
    var strPlanPrice: String = ""
    var productPurchaseCurrencyCode: String = "$"

    // NEW: identifies which product/row the *currently in-flight* price
    // request belongs to. Used to discard stale async results after reuse.
    private var currentRequestProductId: String = ""

    @IBOutlet weak var vwActiveNew: UIView!
    private var imageViews: [UIImageView] = []

    @IBOutlet weak var btnChoosePlanOutlt: UIButton!
    
    @IBOutlet weak var vwChoosePlan: UIView!
    @IBOutlet weak var lblChoosePlan: UILabel!
    @IBOutlet weak var lbl10New: UILabel!
    @IBOutlet weak var lbl9New: UILabel!
    @IBOutlet weak var lbl8New: UILabel!
    @IBOutlet weak var lbl7New: UILabel!
    @IBOutlet weak var lbl6New: UILabel!
    @IBOutlet weak var lbl5New: UILabel!
    @IBOutlet weak var lbl4New: UILabel!
    @IBOutlet weak var lbl3New: UILabel!
    @IBOutlet weak var lbl2New: UILabel!
    @IBOutlet weak var lbl1New: UILabel!
    
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
    
    @IBOutlet weak var lblPlanNameNew: UILabel!
    @IBOutlet weak var lblPriceNew: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        createImageViews()
    }

    // NEW: invalidate any in-flight request as soon as this cell is
    // recycled for a different row, and clear stale text immediately.
    override func prepareForReuse() {
        super.prepareForReuse()
        currentRequestProductId = ""
        lblPriceNew.attributedText = nil
        lblPriceNew.text = nil
    }

    private func createImageViews() {
        let labels = [lbl1New, lbl2New, lbl3New, lbl4New, lbl5New, lbl6New, lbl7New, lbl8New, lbl9New, lbl10New]
        
        for label in labels {
            guard let label = label else { continue }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "icn_Tick_Subscriber")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isHidden = true // Initially hide all image views
            
            contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8), // Position to the left of the label
                imageView.centerYAnchor.constraint(equalTo: label.topAnchor, constant: 12),
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16)
            ])
            
            imageViews.append(imageView)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureViews(for count: Int, withResponse response: membershipPlanResponse?, andIndex idx: Int, planType strPlanType: String, arrFreeContent: [String]) {
        // NEW: any previous in-flight request for this (now reused) cell
        // is no longer relevant.
        currentRequestProductId = ""
        self.idx = idx

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
        
        let strPlanName = "\(response?.data?[idx].name ?? "")"

        lblPlanNameNew.text = strPlanName
        let isActive = response?.data?[idx].isActive ?? false
        vwActiveNew.isHidden = isActive == true ? false : true
        
        if isActive == true
        {
            lblChoosePlan.text = "Current Plan"
            vwChoosePlan.isHidden = false
        }
        else
        {
            if strPlanName == "\(SubscibeUserType.free)"
            {
                vwChoosePlan.isHidden = true
            }
            else
            {
                vwChoosePlan.isHidden = false
                lblChoosePlan.text = "Choose Plan"
            }
        }
        
        if strPlanName == "Free" {
            let attributedString = NSMutableAttributedString(string: "Free", attributes: boldAttributes)
            attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
            attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
            lblPriceNew.attributedText = attributedString
            
        }
        else
        {
             strPlanPrice = "\(response?.data?[idx].billingAmount ?? "0.00")"
            if strPlanPrice == ""
            {
                strPlanPrice = "0.00"
            }
            let productId: String = "\(response?.data?[idx].productId ?? "")"

            // NEW: show the price we already know from the API immediately
            // so the label is never left with a stale/wrong value while
            // the store-price lookup is in flight.
            let fallbackString = NSMutableAttributedString(string: "$\(strPlanPrice)", attributes: boldAttributes)
            fallbackString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
            fallbackString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
            lblPriceNew.attributedText = fallbackString

            // NEW: remember which request this cell is now waiting on.
            currentRequestProductId = productId

            getPurchaseInfo(inappPurchaseId: productId) { [weak self] (price, currencyCode) in
                guard let self = self else { return }

                // NEW: guard against stale callbacks. If this cell has been
                // reused for another row/product since the request started,
                // currentRequestProductId will no longer match — discard.
                guard self.currentRequestProductId == productId else {
                    print("Discarding stale price result for \(productId); cell now shows \(self.currentRequestProductId)")
                    return
                }

                if let price = price, let currencyCode = currencyCode {
                    print("The price is \(currencyCode) \(price)")
                    
                    let formattedPrice = String(format: "%.2f", price)

                    let attributedString = NSMutableAttributedString(string: "\(currencyCode)\(formattedPrice)", attributes: boldAttributes)
                    attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
                    attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
                    self.lblPriceNew.attributedText = attributedString
                    
                } else {
                    print("Failed to retrieve price information")
                    // Fallback already applied above; nothing further to do.
                }
            }
        }
        layoutIfNeeded()
    }
    
    func getPurchaseInfo(inappPurchaseId: String, completion: @escaping (Double?, String?) -> Void) {
        guard !inappPurchaseId.isEmpty else {
            completion(nil, nil)
            return
        }
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([inappPurchaseId]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let price = product.price.doubleValue
                let currencySymbol = product.priceLocale.currencySymbol ?? "?"
                
                print("product.localizedDescription-->\(product.localizedDescription)")
                print("price-->\(price)")
                print("Currency Symbol: \(currencySymbol)")
                
                completion(price, currencySymbol)
            } else {
                completion(nil, nil)
            }
        }
    }
    @IBAction func btnChoosePlanNewTapped(_ sender: Any) {
        if lblPlanNameNew.text != SubscibeUserType.free
        {
            delegate?.cell(self, idx: idx, planName: lblPlanNameNew.text ?? "")
        }
    }
}

/*
import UIKit
import SwiftyStoreKit
protocol SubsciberNewTBCDelegate: AnyObject {
    func cell(_ cell: SubsciberNewTBC, idx: Int, planName: String)
    
}
class SubsciberNewTBC: UITableViewCell {
    weak var delegate: SubsciberNewTBCDelegate?
    var idx: Int = 0
    var strPlanPrice: String = ""
    var productPurchaseCurrencyCode: String = "$"
    
    @IBOutlet weak var vwActiveNew: UIView!
    private var imageViews: [UIImageView] = []

    @IBOutlet weak var btnChoosePlanOutlt: UIButton!
    
    @IBOutlet weak var vwChoosePlan: UIView!
    @IBOutlet weak var lblChoosePlan: UILabel!
    @IBOutlet weak var lbl10New: UILabel!
    @IBOutlet weak var lbl9New: UILabel!
    @IBOutlet weak var lbl8New: UILabel!
    @IBOutlet weak var lbl7New: UILabel!
    @IBOutlet weak var lbl6New: UILabel!
    @IBOutlet weak var lbl5New: UILabel!
    @IBOutlet weak var lbl4New: UILabel!
    @IBOutlet weak var lbl3New: UILabel!
    @IBOutlet weak var lbl2New: UILabel!
    @IBOutlet weak var lbl1New: UILabel!
    
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
    
    @IBOutlet weak var lblPlanNameNew: UILabel!
    @IBOutlet weak var lblPriceNew: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        createImageViews()
    }
    private func createImageViews() {
        let labels = [lbl1New, lbl2New, lbl3New, lbl4New, lbl5New, lbl6New, lbl7New, lbl8New, lbl9New, lbl10New]
        
        for label in labels {
            guard let label = label else { continue }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "icn_Tick_Subscriber")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isHidden = true // Initially hide all image views
            
            contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8), // Position to the left of the label
                imageView.centerYAnchor.constraint(equalTo: label.topAnchor, constant: 12),
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16)
            ])
            
            imageViews.append(imageView)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureViews(for count: Int, withResponse response: membershipPlanResponse?, andIndex idx: Int, planType strPlanType: String, arrFreeContent: [String]) {
       
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
        
//        let strPlanName = "\(response?.data?[idx].name ?? "Free")"
        let strPlanName = "\(response?.data?[idx].name ?? "")"

        lblPlanNameNew.text = strPlanName
        let isActive = response?.data?[idx].isActive ?? false
        vwActiveNew.isHidden = isActive == true ? false : true
        
        if isActive == true
        {
            lblChoosePlan.text = "Current Plan"
            //btnChoosePlanOutlt.isEnabled = false
            vwChoosePlan.isHidden = false
        }
        else
        {
            if strPlanName == "\(SubscibeUserType.free)"
            {
                vwChoosePlan.isHidden = true
            }
            else
            {
                vwChoosePlan.isHidden = false
                lblChoosePlan.text = "Choose Plan"
               // btnChoosePlanOutlt.isEnabled = true
            }
        }
        
        if strPlanName == "Free" {
            let attributedString = NSMutableAttributedString(string: "Free", attributes: boldAttributes)
            attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
            attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
            lblPriceNew.attributedText = attributedString
            
        }
        else
        {
             strPlanPrice = "\(response?.data?[idx].billingAmount ?? "0.00")"
            if strPlanPrice == ""
            {
                strPlanPrice = "0.00"
            }
            let productId: String = "\(response?.data?[idx].productId ?? "")"
          //  self.getPurchaseInfoAccordingtoCountry(ProductId: productId)
            
            getPurchaseInfo(inappPurchaseId: productId) { (price, currencyCode) in
                if let price = price, let currencyCode = currencyCode {
                    print("The price is \(currencyCode) \(price)")
                    
                    let formattedPrice = String(format: "%.2f", price)

                    
                    let attributedString = NSMutableAttributedString(string: "\(currencyCode)\(formattedPrice)", attributes: boldAttributes)
                    attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
                    attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
                    self.lblPriceNew.attributedText = attributedString
                    
                } else {
                    print("Failed to retrieve price information")
                    
                    let attributedString = NSMutableAttributedString(string: "$\(self.strPlanPrice)", attributes: boldAttributes)
                    attributedString.append(NSAttributedString(string: " / ", attributes: lightAttributes))
                    attributedString.append(NSAttributedString(string: "\(strPlanType)", attributes: lightAttributes))
                    self.lblPriceNew.attributedText = attributedString
                }
            }
        }
        layoutIfNeeded()
    }
    
    func getPurchaseInfo(inappPurchaseId: String, completion: @escaping (Double?, String?) -> Void) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([inappPurchaseId]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let price = product.price.doubleValue
                let currencySymbol = product.priceLocale.currencySymbol ?? "?"
                
                print("product.localizedDescription-->\(product.localizedDescription)")
                print("price-->\(price)")
                print("Currency Symbol: \(currencySymbol)")
                
                completion(price, currencySymbol)
            } else {
                completion(nil, nil)
            }
        }
    }
    @IBAction func btnChoosePlanNewTapped(_ sender: Any) {
        if lblPlanNameNew.text != SubscibeUserType.free
        {
//            delegate?.cell(self, idx: idx, planName: lblPlanNameNew.text ?? "Free")
            delegate?.cell(self, idx: idx, planName: lblPlanNameNew.text ?? "")

        }
    }
}
*/
