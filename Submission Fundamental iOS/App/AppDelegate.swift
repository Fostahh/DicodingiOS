//
//  AppDelegate.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeviewModel = HomeViewModel(useCase: Injection.init().provideHome())
        let homeViewController = HomeViewController(viewModel: homeviewModel)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        let favoriteViewModel = FavoriteViewModel(useCase: Injection.init().provideFavorite())
        let favoriteViewController = FavoriteViewController(viewModel: favoriteViewModel)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, favoriteNavigationController, BiodataViewController()]
        
        tabBarController.viewControllers?[0].title = "Games"
        tabBarController.viewControllers?[0].tabBarItem.image = UIImage(systemName: "gamecontroller")
        
        tabBarController.viewControllers?[1].title = "Favorite"
        tabBarController.viewControllers?[1].tabBarItem.image = UIImage(systemName: "heart.fill")
        
        tabBarController.viewControllers?[2].title = "Profile"
        tabBarController.viewControllers?[2].tabBarItem.image = UIImage(systemName: "person")
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
