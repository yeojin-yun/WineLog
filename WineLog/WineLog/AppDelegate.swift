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
        
        let categoryVC = MyWineListVC()
        let firstNavVC = UINavigationController(rootViewController: categoryVC)
        let wishListVC = AddWineCategoryVC()
        let secondNavVC = UINavigationController(rootViewController: wishListVC)
        let tabBarController = UITabBarController()
        
//        firstNavVC.tabBarItem = UITabBarItem(title: "Domino/'s", image: UIImage(named: "domino's"), tag: 0)
        tabBarController.viewControllers = [firstNavVC, secondNavVC]
        
        window?.rootViewController = tabBarController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
