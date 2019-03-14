//
//  ColumnController.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
class ColumnController: UICollectionViewController,
UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ColumnNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        self.title = "Köşe Yazıları"
        getColumnNews()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columnNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ColumnNewsCollectionViewCell
        cell.columnNews = self.columnNews[indexPath.item]
        return cell
    }
    
    
    var columnNews:[ColumnModelElement] = []
    
    private let disposeBag = DisposeBag()
    func getColumnNews(){
        ApiClient.getColumnNews()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (news) in
                self.columnNews = news
            }, onError: { (error) in
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
