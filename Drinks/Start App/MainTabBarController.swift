//
//  MainTabBarController.swift
//  Drinks
//
//  Created by admin on 24.05.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    public var drinkViewModel: DrinkViewModel?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .yellow
        self.tabBar.barTintColor = .lightBrownBackgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }

    func configure() {
       
        let drinkVC = DrinkViewController()
        let navVC = UINavigationController(rootViewController: drinkVC)
        drinkVC.drinkViewModel = self.drinkViewModel
        drinkVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")

        let favoritesVC = FavoritesViewController()
        let navFavoritesVC = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.coreDataStack = drinkViewModel?.coreDataStack
        favoritesVC.drinkViewModel = drinkViewModel

        favoritesVC.tabBarItem.image = UIImage(systemName: "heart")

        viewControllers = [navVC, navFavoritesVC]
    }
}
