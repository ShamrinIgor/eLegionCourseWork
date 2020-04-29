//
//  AppDelegate.swift
//  Week3TestWork
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        let dataManager = CoreDataManager(modelName: "TeamManager")
//        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let navigator = UINavigationController()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainVC = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
//        mainVC.dataManager = dataManager
//        navigator.viewControllers = [mainVC]
//        
//        self.window?.rootViewController = navigator
//        self.window?.makeKeyAndVisible()
  
        return true
    }
    
    func switchViewControllers() {
        print("rofl")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
        self.window?.rootViewController = viewController
    }
}
