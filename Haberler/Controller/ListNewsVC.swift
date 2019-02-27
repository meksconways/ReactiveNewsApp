//
//  ListNewsVC.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class ListNewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = news[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! MainListTableViewCell
        cell.setData(model: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        // tableview in otomatik boyutunu belirtir
    }
    
    var news : [ArticleNewsModelElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getAllNews()
    }
    
    let mainView:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let table_view : UITableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
        
        
    }()
    
    func setupUI(){
        
        self.view.addSubview(mainView)
        mainView.addSubview(table_view)
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
        table_view.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
        
        table_view.separatorStyle = .singleLine
        table_view.separatorInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        //table_view.backgroundColor = UIColor(rgb: 0xebebeb)
        table_view.delegate = self
        table_view.dataSource = self
        table_view.register(MainListTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        
       
        
    }
    
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
                self.table_view.reloadData()
                
            })
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class MainListTableViewCell : UITableViewCell {
    
    
    let mainView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0 // sıfır kısıtlama
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(model: ArticleNewsModelElement){
        titleText.text = model.title
    }
    
    func setupUI(){
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        mainView.addSubview(titleText)
        titleText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
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
