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
        self.tabBar.tintColor = UIColor(rgb: 0xc54545)
        
        let layout = UICollectionViewFlowLayout()
        let controller = MainViewController(collectionViewLayout: layout)
        controller.tabBarItem.title = "Haberler"
        controller.tabBarItem.image = UIImage(named: "tab_1")
       
        let lay2 = UICollectionViewFlowLayout()
        let columnController = ColumnController(collectionViewLayout: lay2)
        columnController.tabBarItem.title = "Köşe Yazıları"
        columnController.tabBarItem.image = UIImage(named: "tab_2")
        
        let lay3 = UICollectionViewFlowLayout()
        let galleryController = GalleryController(collectionViewLayout: lay3)
        galleryController.tabBarItem.title = "Haber Galerisi"
        galleryController.tabBarItem.image = UIImage(named: "tab_3")
        
        
        
        viewControllers = [UINavigationController(rootViewController: controller),
                           UINavigationController(rootViewController: columnController),
                            UINavigationController(rootViewController: galleryController)]
    }
    

}
