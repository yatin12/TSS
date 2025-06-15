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
    // In CustomeTabbarVC.swift
    private func stopAllVideos() {
        // Post notification to stop videos
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil)
        
        // Find HomeVC in navigation stack and directly call stopAllVideos
        if let navController = self.viewControllers?[0] as? UINavigationController,
           let homeVC = navController.viewControllers.first as? HomeVC {
            homeVC.stopAllVideos()
        }
    }
    /*
    private func stopAllVideos() {
           // Post notification to stop videos
           NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil)
           
           // Also directly stop any playing video in HomeVC if it's in the view hierarchy
           if let navController = self.viewControllers?[0] as? UINavigationController,
              let homeVC = navController.viewControllers.first as? HomeVC {
               homeVC.stopAllVideos()
           }
       }
    */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // Stop all videos first
             stopAllVideos()
        
        if(item.tag == 0) {
            //Home
        
           // print("Code for item 0")
            NotificationCenter.default.post(name: Notification.Name("APIcallforHome"), object: nil, userInfo: nil)

            
        }
        if(item.tag == 1) {
            //Talk Show
            isFromViewAll = false
            strSelectedPostName = "talk_shows"
            NotificationCenter.default.post(name: Notification.Name("APICall_TalkShow"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)


        }
        if(item.tag == 2) {
            //PodCast
            isFromViewAll = false
            
            NotificationCenter.default.post(name: Notification.Name("APIcall_PodCast"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)
            
        }
        if(item.tag == 3) {
            //News
           // print("Code for item 1")
            isFromViewAll = false
            NotificationCenter.default.post(name: Notification.Name("APICall_News"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)

        }
        if(item.tag == 4) {
            //PodCast
            isFromViewAll = false
            
            NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil, userInfo: nil)

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
