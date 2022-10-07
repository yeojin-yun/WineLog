//
//  AppDelegate.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstNavVC = UINavigationController(rootViewController: AddWineCategoryVC())
        let secondNavVC = UINavigationController(rootViewController: MyWineListVC())
        let tabBarController = UITabBarController()
        
        firstNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus"), tag: 0)
        secondNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.bullet"), tag: 1)
        tabBarController.viewControllers = [firstNavVC, secondNavVC]
        
        window?.rootViewController = tabBarController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
