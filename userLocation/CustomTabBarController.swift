//
//  CustomTabBarController.swift
//  userLocation
//
//  Created by Lisa Steele on 4/5/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //let WelcomeController = WelcomeViewController()
        //let navigationController = UINavigationController(rootViewController: WelcomeController)
        
        let LoginController = LoginViewController()
        let navControllerTwo = UINavigationController(rootViewController: LoginController)
        
        
        let FavoritesController = FavoriteLocationsTableViewController()
        let navControllerThree = UINavigationController(rootViewController: FavoritesController)
        navigationController?.title = "Favorites"
        
        let MapController = ViewController()
        let navControllerFour = UINavigationController(rootViewController: MapController)
        navigationController?.title = "Add Location"
        
        let SaveLocDetailController = SaveLocationDetailViewController()
        let navControllerFive = UINavigationController(rootViewController: SaveLocDetailController)
        
        
        viewControllers = [navControllerTwo, navControllerThree, navControllerFour, navControllerFive]
    }
}
