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
        collectionView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.delegate = self
        collectionView.register(ArticlesNewsCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(SubArticleNewsCell.self, forCellWithReuseIdentifier: subCellID)
        self.title = "Haberler"
        
        getAllNews()
    }
    
    func showNewsDetail(newsID:String) {
        
        let layout = UICollectionViewFlowLayout()
        let detailController = NewsDetailController(collectionViewLayout: layout)
        navigationController?.pushViewController(detailController, animated: true)
        
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
        }else{
            return CGSize(width: view.bounds.width, height: 260)
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticlesNewsCell
            cell.newsList = self.news
            cell.mainViewController = self
            return cell
        }
        else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Dünya Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path == "/dunya/"
            })
            return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Spor Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path.contains("spor")
            })
            return cell
        }
        else if indexPath.section == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Gündem Haberleri"
            cell.mainViewController = self
            cell.subNews = self.news.filter({ (element) -> Bool in
                element.path == "/gundem/"
            })
            return cell
            
        }
        else if indexPath.section == 4{
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
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
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


