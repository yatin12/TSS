//
//  SplashScreenVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    
}
extension SplashScreenVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigateToNextViewAfterDelay()
        
    }
}
//MARK: General Methods
extension SplashScreenVC
{
    func navigateToNextViewAfterDelay() {
        let delayInSeconds: Double = 2.0 // Adjust the delay as needed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            // Perform your navigation here
            self.userState()
        }
    }
    
     func userState() {
         let appStatus : String = AppUserDefaults.object(forKey: "isUserLoggedIn") as? String ?? "NO"
        if appStatus == "NO" {
            NavigationHelper.push(storyboardKey.IntroScreen, viewControllerIdentifier: "LoginVC", from: navigationController!, animated: true)
        }
        else
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "HomeNev", from: self.navigationController!, animated: true)
        }
    }
}
