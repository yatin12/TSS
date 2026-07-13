
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
        selectedIndex = 4
        
        // Hide the native tab bar completely
        tabBar.isHidden = true
        
        // Build custom tab bar
        setupCustomTabBar()
    }

    // MARK: - Custom Tab Bar
    var customTabBar: UIView!
    var tabButtons: [UIButton] = []
    let tabItems: [(icon: String, selectedIcon: String, title: String)] = [
        ("Home_UnSelect", "Home_Select", "Home"),
        ("Talk_Show_UnSelect", "Talk_Show_Select", "Talk-Show"),
        ("Podcast_Unselect", "Podcast_Select", "Podcast"),
        ("News_UnSelect", "News_Select", "News"),
        ("Explore_Select", "Explore_Select", "Explore")
    ]
    func setupCustomTabBar() {
        let tabBarHeight: CGFloat = 83
        let bottomInset = view.safeAreaInsets.bottom == 0 ? 0 : view.safeAreaInsets.bottom

        customTabBar = UIView()
        customTabBar.backgroundColor = AppColors.ThemePinkColor
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)

        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight + bottomInset)
        ])

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: tabBarHeight)
        ])

        tabButtons = []
        for (index, item) in tabItems.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = index
            button.addTarget(self, action: #selector(customTabTapped(_:)), for: .touchUpInside)

            let isSelected = index == selectedIndex   // ✅ use selectedIndex, not hardcoded 0

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: isSelected ? item.selectedIcon : item.icon)
            imageView.tintColor = .white
            imageView.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = item.title
            label.textColor = .white
            label.textAlignment = .center

            label.font = UIFont(name: isSelected ? AppFontName.Poppins_Bold.rawValue : AppFontName.Poppins_Medium.rawValue,
                                 size: isSelected ? 13 : 10) ?? UIFont.systemFont(ofSize: 10)

            label.translatesAutoresizingMaskIntoConstraints = false

            let container = UIStackView(arrangedSubviews: [imageView, label])
            container.axis = .vertical
            container.alignment = .center
            container.spacing = 3
            container.isUserInteractionEnabled = false
            container.translatesAutoresizingMaskIntoConstraints = false

            button.addSubview(container)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24),
                container.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                container.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])

            stackView.addArrangedSubview(button)
            tabButtons.append(button)
        }
    }
    

    @objc func customTabTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
        stopAllVideos()

        // Update button states
        for (i, button) in tabButtons.enumerated() {
            let item = tabItems[i]
            let imageView = (button.subviews.first as? UIStackView)?.arrangedSubviews.first as? UIImageView
            let label = (button.subviews.first as? UIStackView)?.arrangedSubviews.last as? UILabel
            imageView?.image = UIImage(named: i == index ? item.selectedIcon : item.icon)
            
      label?.font = UIFont(name: i == index ? AppFontName.Poppins_Bold.rawValue : AppFontName.Poppins_Medium.rawValue, size: i == index ? 13 : 10)
        }

        // Post notifications
        let notifications = [
            "APIcallforHome", "APICall_TalkShow", "APIcall_PodCast", "APICall_News", ""
        ]
        if index < notifications.count && !notifications[index].isEmpty {
            isFromViewAll = false
            if index == 1 { strSelectedPostName = "talk_shows" }
            NotificationCenter.default.post(name: Notification.Name(notifications[index]), object: nil)
        }
        NotificationCenter.default.post(name: Notification.Name("APIcallforVideoStop"), object: nil)
    }
    

    func setupTabBarFont() {

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Normal state
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont(
                name: AppFontName.Poppins_Medium.rawValue,
                size: 12
            ) ?? UIFont.systemFont(ofSize: 12),
            
            .foregroundColor: UIColor.gray
        ]

        // Selected state
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont(
                name: AppFontName.Poppins_Bold.rawValue,
                size: 12
            ) ?? UIFont.boldSystemFont(ofSize: 12),
            
            .foregroundColor: UIColor.black
        ]

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
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
