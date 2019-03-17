//
//  SubArticleNewsCell.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class SubArticleNewsCell: UICollectionViewCell,
UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    var mainViewController: MainViewController?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: -10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = subNews?[indexPath.item]{
            mainViewController?.showNewsDetail(newsID: model.id)
        }
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
        viewAllBtn.addTapGestureRecognizer {
            
            switch self.title.text{
            case "Spor Haberleri":
                self.mainViewController?.showAllCategoryNews(keyword: "spor",pageTitle:"Spor")
            case "Dünya Haberleri":
                self.mainViewController?.showAllCategoryNews(keyword: "sinema",pageTitle:"Dünya")
            case "Gündem Haberleri":
                self.mainViewController?.showAllCategoryNews(keyword: "gundem", pageTitle:"Gündem")
            case "Magazin Haberleri":
                self.mainViewController?.showAllCategoryNews(keyword: "magazin", pageTitle:"Magazin")
            default:
                return
            }
            
        }
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
    
    let viewAllBtn: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tümünü Gör", for: UIControl.State.normal)
        button.titleLabel?.font =  UIFont(name: "Dosis-SemiBold", size: 14)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(rgb: 0x797979), for: UIControl.State.normal)
        return button
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
        addSubview(viewAllBtn)
        
        viewAllBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(100)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(viewAllBtn.snp.left).offset(-10)
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
        image.backgroundColor = UIColor(rgb: 0xa0a0a0)
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
            make.top.equalToSuperview()
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            
        }
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 12.0
    }
    
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
