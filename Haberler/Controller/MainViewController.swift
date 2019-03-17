//
//  MainViewController.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        collectionView.backgroundColor = UIColor.white
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.delegate = self
        collectionView.register(ArticlesNewsCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(SubArticleNewsCell.self, forCellWithReuseIdentifier: subCellID)
        collectionView.register(CategoriesBaseCell.self, forCellWithReuseIdentifier: "catid")
        self.title = "Haberler"
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        self.createCategories()
        collectionView.refreshControl = refreshControl
        //refreshControl.tintColor = UIColor.white
        //collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        getAllNews()
        
    }
    let refreshControl = UIRefreshControl()
    let indicator = UIActivityIndicatorView(style: .gray)
    @objc func refresh(){
        if news.count > 0 {
            news.removeAll()
            getAllNews()
        }
    }
    
    func showNewsDetail(newsID:String) {
        
        let detailController = NewsDetailController()
        detailController.newsId = newsID
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    func showAllCategoryNews(keyword: String,pageTitle:String){
        let layout = UICollectionViewFlowLayout()
        let controller = ViewAllNewsController(collectionViewLayout: layout)
        controller.pageTitle = pageTitle
        controller.keyword = keyword
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    private var selectingCount:Int = 0
    private var alreadyRoot:Bool = true //singleton
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            selectingCount += 1
            
            if alreadyRoot{
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                alreadyRoot = false
                return
            }
            
            if selectingCount > 1{
                if tabBarController.selectedViewController?.navigationItem.title == "Haberler"{
                    self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                }else{
                    selectingCount -= 1
                }
                
            }
            
        }else{
            selectingCount = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            return CGSize(width: view.bounds.width, height: view.bounds.width * 11 / 16)
        }else if indexPath.section == 1{
            return CGSize(width: view.bounds.width, height: 120)
        }
        
        else{
            return CGSize(width: view.bounds.width, height: 260)
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticlesNewsCell
            cell.newsList = self.news
            cell.mainViewController = self
            return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catid", for: indexPath) as! CategoriesBaseCell
            cell.model = self.categories
            cell.mainController = self
            return cell
        }
        else if indexPath.section == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Dünya Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path == "/dunya/"
            })
            return cell
        }
        else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Spor Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path.contains("spor")
            })
            return cell
        }
        else if indexPath.section == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Gündem Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path == "/gundem/"
            })
            return cell
            
        }
        else if indexPath.section == 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Magazin Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path.contains("magazin") || element.path.contains("kelebek")
            })
            return cell
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Gündem Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path == "/gundem/"
            })
            return cell
        }
        
        
    }
    let subCellID: String = "subCellID"
    let cellID: String = "cellID"
    var news:[ArticleNewsModelElement] = []
    
    private let disposeBag = DisposeBag()
    
    func getAllNews(){
        ApiClient.getArticleNews()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {newsList in
                    self.news = newsList
            },
                onError: { error in
                    switch error {
                    case ApiError.conflict:
                        print("Conflict error")
                    case ApiError.forbidden:
                        print("Forbidden error")
                    case ApiError.notFound:
                        print("Not found error")
                    default:
                        print("Unknown error:", error)
                    }
            }, onCompleted: {
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                if self.indicator.isAnimating {
                    self.indicator.stopAnimating()
                }
                
                self.collectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
    }
    
    func createCategories(){
        var i = 0
        for (_,_) in kategoriler{
            self.categories.append(Categories(name: catName[i], keyword: catKeyword[i], photo: photos[i]))
            i += 1
        }
    }
    
    var categories:[Categories] = []
    var catName:[String] = ["Tiyatro","Ekonomi","Seyahat","Astroloji","Sağlık","Teknoloji","Sinema","Eğitim","Avrupa","Ramazan"]
    var catKeyword: [String] = ["tiyatro","ekonomi","seyahat","astroloji","saglik","teknoloji","sinema","egitim","avrupa","ramazan"]
    var photos : [String] = ["theater","economy","journey","leo","health","technology","cinema","education","europe","ramadan"]
    var kategoriler : [String:String] = ["Tiyatro":"tiyatro",
                                      "Ekonomi":"ekonomi",
                                      "Seyahat":"seyahat",
                                      "Sağlık":"saglik",
                                      "Teknoloji":"teknoloji",
                                      "Sinema":"sinema",
                                      "Eğitim":"egitim",
                                      "Avrupa":"avrupa",
                                      "Ramazan":"ramazan","asd":"asd"]
}

struct Categories {
    let name:String
    let keyword:String
    let photo: String
}

class CategoriesBaseCell: UICollectionViewCell,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var model:[Categories]?{
        didSet{
            subCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var mainController: MainViewController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let modelX = model?[indexPath.item]{
            mainController?.showAllCategoryNews(keyword: modelX.keyword, pageTitle: modelX.name)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCell {
                cell.imageView.transform = .init(scaleX: 0.86, y: 0.86)
            }
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCell {
                cell.imageView.transform = .identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = model?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = subCollectionView.dequeueReusableCell(withReuseIdentifier: "catid", for: indexPath) as! CategoriesCell
        cell.categories = self.model?[indexPath.item]
        return cell
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let title: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont(name: "Dosis-SemiBold", size: 20)
        label.textColor = UIColor(rgb: 0x323232)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Kategoriler"
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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    func setupUI(){
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: "catid")
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
            make.top.equalTo(title.snp.bottom).offset(2)
            make.height.equalTo(68)
        }
    }
}

class CategoriesCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var categories:Categories?{
        didSet{
            if let ph = categories?.photo{
                imageView.image = UIImage(named: ph)
            }
            if let name = categories?.name{
                catName.text = name
            }
            
        }
    }
    
    let imageView:UIImageView = {
       let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    let catName:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "Dosis-SemiBold", size: 12.0)
        label.textColor = UIColor(rgb: 0x323232)
        label.textAlignment = .center
        return label
    }()
    
    func setupUI(){
        addSubview(imageView)
        addSubview(catName)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(40)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.0)
            make.centerX.equalToSuperview()
            
        }
        catName.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            
            
        }
        imageView.clipsToBounds = true
    }
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Geçersiz red component")
        assert(green >= 0 && green <= 255, "Geçersiz green component")
        assert(blue >= 0 && blue <= 255, "Geçersiz blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


