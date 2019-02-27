//
//  ViewController.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getNews()
        
    }
    
    func getNews(){
        ApiClient.getArticleNews()
        .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {newsList in
                print("NewsList:", newsList)
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
            })
            .disposed(by: disposeBag)
    }
    
    


}

