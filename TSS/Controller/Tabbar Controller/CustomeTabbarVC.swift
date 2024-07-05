//
//  CustomeTabbarVC.swift
//  Driver007
//
//  Created by Macbook on 17/07/21.
//

import UIKit
class RoundShadowView: UIView {

    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
      //  layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
/*
    func layoutView() {

        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -8.0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    */
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
class CustomeTabbarVC: UITabBarController {

    @IBOutlet weak var tabBarOutlt: UITabBar!
    var appdel : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appdel = AppDelegate().sharedInstance()
        self.navigationController?.isNavigationBarHidden = true
     
       selectedIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag == 0) {
            //Home
        
           // print("Code for item 0")
          //  NotificationCenter.default.post(name: Notification.Name("APIcallforMyJobsTab"), object: nil, userInfo: nil)

            
        }
        if(item.tag == 1) {
            //News
           // print("Code for item 1")
            isFromViewAll = false
           // NotificationCenter.default.post(name: Notification.Name("APIcallforSiteInspectionTab"), object: nil, userInfo: nil)
        }
        if(item.tag == 2) {
            //Talk Show
            isFromViewAll = false
            
           // NotificationCenter.default.post(name: Notification.Name("APIcallforProfileTab"), object: nil, userInfo: nil)
        }
        if(item.tag == 3) {
            //E video
            isFromViewAll = false
            
           // NotificationCenter.default.post(name: Notification.Name("APIcallforProfileTab"), object: nil, userInfo: nil)
        }
        if(item.tag == 4) {
            //PodCast
            isFromViewAll = false
            
            NotificationCenter.default.post(name: Notification.Name("APIcallforProfileTab"), object: nil, userInfo: nil)
        }
    }
    override var traitCollection: UITraitCollection {
            guard UIDevice.current.userInterfaceIdiom == .pad else {
                return super.traitCollection
            }

            return UITraitCollection(traitsFrom: [super.traitCollection, UITraitCollection(horizontalSizeClass: .compact)])
        }
   
    
}
extension UIView{
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
}
