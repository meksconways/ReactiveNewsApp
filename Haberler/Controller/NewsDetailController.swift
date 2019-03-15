//
//  NewsDetailController.swift
//  Haberler
//
//  Created by macbook  on 15.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import SnapKit
class NewsDetailController: UICollectionViewController,
UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: "headerid")
        //self.title = "Haber Detay"
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.width * 4 / 4)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerid", for: indexPath) as! HeaderCell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

class HeaderCell: BaseCell{
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bgi_2")
        return iv
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
    }
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
    }
    
}
