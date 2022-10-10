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
        navigationBarConfiguration(firstNavVC)
        let secondNavVC = UINavigationController(rootViewController: MyWineListVC())
        navigationBarConfiguration(secondNavVC)
        let tabBarController = UITabBarController()
        
        firstNavVC.tabBarItem.title = "Add"
        firstNavVC.tabBarItem.image = UIImage(named: "wineGlass")
        firstNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 110, left: 100, bottom: 110, right: 100)
        secondNavVC.tabBarItem.title = "List"
//        secondNavVC.tabBarItem.image = UIImage(systemName: "list.bullet.circle.fill")
        secondNavVC.tabBarItem.image = UIImage(named: "wineryIcon")
        secondNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 110, left: 100, bottom: 110, right: 100)
        
        tabBarController.viewControllers = [firstNavVC, secondNavVC]
        tabBarController.tabBar.tintColor = .myGreen
        tabBarController.tabBar.unselectedItemTintColor = .myGreen?.withAlphaComponent(0.3)
        
        window?.rootViewController = tabBarController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func navigationBarConfiguration(_ controller: UINavigationController) {
        controller.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        controller.navigationBar.tintColor = UIColor.darkGray
        controller.navigationBar.backgroundColor = .white
        let backbarButton = UIBarButtonItem(title: "fff", style: .plain, target: nil, action: nil)
        controller.navigationItem.backBarButtonItem = backbarButton
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.backgroundColor = UIColor.white
            navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
            controller.navigationBar.standardAppearance = navBarAppearance
            controller.navigationBar.scrollEdgeAppearance = navBarAppearance
            controller.navigationBar.compactAppearance = navBarAppearance
            
            let backbarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            controller.navigationItem.backBarButtonItem = backbarButton
        }
    }
    
}
