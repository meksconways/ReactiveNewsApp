//
//  NewsDetailController.swift
//  Haberler
//
//  Created by macbook  on 15.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher
class NewsDetailController: UICollectionViewController,
UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.newsId!)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: "headerid")
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "titleid")
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = UIColor.white
        getNewsDetail()
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
    
    private let disposeBag = DisposeBag()
    var newsDetailModel: NewsDetailModel?
    func getNewsDetail(){
        ApiClient.getNewsDetail(newsId: newsId!)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (newsDetail) in
                print(newsDetail)
                self.newsDetailModel = newsDetail
            }, onError: { (error) in
                // todo sc
            }, onCompleted: {
                self.collectionView.reloadData()
            })
        .disposed(by: disposeBag)
    }
    
    var newsId: String?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: self.view.bounds.width, height: self.view.bounds.width * 3 / 4)
        }else{
            return CGSize(width: self.view.bounds.width, height: 60)
        }
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerid", for: indexPath) as! HeaderCell
            cell.model = self.newsDetailModel
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleid", for: indexPath) as! TitleCell
            cell.titleModel = self.newsDetailModel
            return cell
        }
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

class TitleCell: BaseCell {
    
    var titleModel: NewsDetailModel?{
        didSet{
             title.text = titleModel?.title
        }
    }
    
    let title: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-Bold", size: 22)
        label.text = "Haberlerde BuGün\nmerhaba"
        label.textColor = UIColor(rgb: 0x323232)
        label.numberOfLines = 2
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

class HeaderCell: BaseCell,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    var model: NewsDetailModel?{
        didSet{
            self.collectionV.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = model?.files.count {
            self.pageController.numberOfPages = count
            return count
            
        }
        self.pageController.numberOfPages = 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.width * 3 / 4)
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
        cell.model = self.model?.files[indexPath.item]
        return cell
    }
    
    let pageController: UIPageControl = {
        let pc = UIPageControl()
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
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        return iv
    }()
    
    var model: File?{
        didSet{
          
            let url = URL(string: (model?.fileURL)!)!
            imageView.kf.setImage(with: url)
        }
    }
    
    
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
