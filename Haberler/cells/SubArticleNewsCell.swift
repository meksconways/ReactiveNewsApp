//
//  SubArticleNewsCell.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import SnapKit
class SubArticleNewsCell: UICollectionViewCell,
UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = subNews?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = subCollectionView.dequeueReusableCell(withReuseIdentifier: "subCellId", for: indexPath) as! SubArticlesNewsCollectionViewCell
        cell.model = subNews?[indexPath.item]
        return cell
        
    }
    
    
    var subNews:[ArticleNewsModelElement]?{
        didSet{
            
            self.subCollectionView.reloadData()
        }
    }
    var pathName:String?{
        didSet{
            title.text = pathName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let title: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont(name: "Dosis-SemiBold", size: 20)
        label.textColor = UIColor(rgb: 0x323232)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Spor Haberleri"
        label.numberOfLines = 0
        return label
        
    }()
    
    let subCollectionView: UICollectionView = {
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
    
    func setupUI(){
        
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.register(SubArticlesNewsCollectionViewCell.self, forCellWithReuseIdentifier: "subCellId")
        
        addSubview(subCollectionView)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        subCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(title.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    
}

class SubArticlesNewsCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let newsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-SemiBold", size: 16.0)
        label.numberOfLines = 3
        label.textColor = UIColor(rgb: 0x212121)
        return label
    }()
    
    let subView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var model: ArticleNewsModelElement?{
        didSet{
            newsText.text = model?.title
            let imageURL = URL(string: model!.files[0].fileURL)!
            newsImage.kf.setImage(with: imageURL)
        }
    }
    
    func setupUI(){
        addSubview(newsImage)
        addSubview(newsText)
        
        
        newsImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(newsImage.snp.width).multipliedBy(1.0)
        }
        newsText.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            
        }
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 12.0
    }
    
}
