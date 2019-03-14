//
//  GalleryController.swift
//  Haberler
//
//  Created by macbook  on 14.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation
import UIKit

class GalleryController: UICollectionViewController,
UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        collectionView.backgroundColor = UIColor.white
        self.title = "Haber Galerisi"
    }
    
}
