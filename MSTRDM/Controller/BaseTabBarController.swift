//
//  BaseTabBarController.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 28.12.2020.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createNavController(viewController: NewsController(), title: "Лента", imageName: "newspaper"),
        ]
    }
    
    // Метод создает Navigation controller
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .red
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarController?.tabBar.barTintColor = .red
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barTintColor = .black
        return navController
    }
    
}
