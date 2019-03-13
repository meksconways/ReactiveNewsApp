//
//  MainViewController.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.white
        collectionView.register(ArticlesNewsCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(SubArticleNewsCell.self, forCellWithReuseIdentifier: subCellID)
        self.title = "Haberler"
        getAllNews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            return CGSize(width: view.bounds.width, height: view.bounds.width * 12 / 16)
        }else{
            return CGSize(width: view.bounds.width, height: 260)
        }
        
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticlesNewsCell
            cell.newsList = self.news
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellID, for: indexPath) as! SubArticleNewsCell
            cell.pathName = "Dünya Haberleri"
            cell.subNews = self.news
//            cell.subNews = self.news.filter({ (element) -> Bool in
//                element.path == "/dunya/"
//            })
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
                // hide progress
                self.collectionView.reloadData()
                //self.table_view.reloadData()
                //let cell = self.table_view.dequeueReusableCell(withIdentifier: "SporCell") as! SubNewsTableViewCell
                //cell.setData(model: self.news)
                
            })
            .disposed(by: disposeBag)
    }
}


