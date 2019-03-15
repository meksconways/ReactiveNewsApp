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
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.width * 3 / 4)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerid", for: indexPath) as! HeaderCell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

class HeaderCell: BaseCell,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.width * 3 / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // self.pageController.currentPage = indexPath.item
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "headerphotoid", for: indexPath)
            as! NewsDetailHeaderPhotoCollectionViewCell
        return cell
    }
    
    let pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.isEnabled = false
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = UIColor.white
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        return pc
    }()
    
    let collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.flashScrollIndicators()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    
    override func setupUI() {
        super.setupUI()
        addSubview(collectionV)
        addSubview(pageController)
        collectionV.register(NewsDetailHeaderPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "headerphotoid")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        pageController.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }
    }
}

class NewsDetailHeaderPhotoCollectionViewCell : BaseCell{
    
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
