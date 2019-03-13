//
//  MainTabBarControllerViewController.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let controller = MainViewController(collectionViewLayout: layout)
        controller.tabBarItem.title = "Haberler"
        controller.tabBarItem.image = UIImage(named: "tab1")
        self.tabBar.tintColor = UIColor(rgb: 0xc54545)
        viewControllers = [UINavigationController(rootViewController: controller)]
    }
    

}
