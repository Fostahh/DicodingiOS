//
//  MainFlowController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import UIKit
import Core
import Home
import Biodata
import Favorite
import DetailGame

class MainFlowController {
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.injection = Injection()
    }
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let injection: Injection
    
    // MARK: - Public Methods
    func start() {
        let initialViewController = createInitialScreen()
        window.rootViewController = initialViewController
    }
    
    // MARK: - Private Methods
    private func createInitialScreen() -> UITabBarController {
        let homeNavigationController = createHomeScreen()
        let favoriteNavigationController = createFavoriteScreen()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, favoriteNavigationController, BiodataViewController()]
        
        tabBarController.viewControllers?[0].title = "tab_bar_title_home".localized()
        tabBarController.viewControllers?[0].tabBarItem.image = UIImage(systemName: "gamecontroller")
        
        tabBarController.viewControllers?[1].title = "tab_bar_title_favorite".localized()
        tabBarController.viewControllers?[1].tabBarItem.image = UIImage(systemName: "heart.fill")
        
        tabBarController.viewControllers?[2].title = "tab_bar_title_profile".localized()
        tabBarController.viewControllers?[2].tabBarItem.image = UIImage(systemName: "person")
        
        return tabBarController
    }
    
    private func createHomeScreen() -> UINavigationController {
        let homeviewModel = HomeViewModel(useCase: injection.provideHome())
        let homeViewController = HomeViewController(viewModel: homeviewModel)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        homeViewController.onNavigationEvent = { [weak self, weak homeNavigationController] (event: HomeViewController.Navigation) in
            switch event {
            case .detailVideoGame(let videoGameId):
                self?.navigateToDetailVideoGameScreen(from: homeNavigationController, id: videoGameId)
            }
        }
        
        return homeNavigationController
    }
    
    private func createFavoriteScreen() -> UINavigationController {
        let favoriteViewModel = FavoriteViewModel(useCase: injection.provideFavorite())
        let favoriteViewController = FavoriteViewController(viewModel: favoriteViewModel)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        
        favoriteViewController.onNavigationEvent = { [weak self, weak favoriteNavigationController] (event: FavoriteViewController.Navigation) in
            switch event {
            case .detailVideoGame(let videoGameId):
                self?.navigateToDetailVideoGameScreen(from: favoriteNavigationController, id: videoGameId, isFromFavoriteScreen: true)
            }
        }
        
        return favoriteNavigationController
    }
    
    private func navigateToDetailVideoGameScreen(
        from navigationController: UINavigationController?,
        id: Int,
        isFromFavoriteScreen: Bool = false
    ) {
        let detailVM = DetailGameViewModel(useCase: injection.provideDetail(), gameId: id)
        let detailVC = DetailGameViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
