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
        favoritesVC.tabBarItem.image = UIImage(systemName: "heart")

        viewControllers = [navVC, favoritesVC]
    }
}
