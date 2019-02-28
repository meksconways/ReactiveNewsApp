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
import Kingfisher

class ListNewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! MainListTableViewCell
        cell.selectionStyle = .none
        cell.setData(model: self.news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 11 / 16
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 11 / 16
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
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 0.5)
        self.view.addSubview(mainView)
        mainView.addSubview(table_view)
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
        table_view.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        table_view.rowHeight = UITableView.automaticDimension
        table_view.separatorStyle = .singleLine
        table_view.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        table_view.backgroundColor = UIColor(rgb: 0xebebeb)
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
                let cell = self.table_view.dequeueReusableCell(withIdentifier: "NewsCell") as! MainListTableViewCell
                cell.newsList = self.news
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
}

class MainListTableViewCell : UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.window?.frame.width)!, height: (self.window?.frame.width)! * 11 / 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = newsList[indexPath.row]
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! TopNewsCollectionViewCell
        cell.setData(model: model)
        return cell
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    var newsList : [ArticleNewsModelElement] = []
    
    
    func setData(model: [ArticleNewsModelElement]){
        print("***",model.count)
        self.newsList = model
    }
    
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var collectionview : UICollectionView!
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9 / 16)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionview = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionview.isPagingEnabled = true
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(TopNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionview.showsHorizontalScrollIndicator = false
        addSubview(collectionview)
        collectionview.reloadData()
        
    }
    
}

class TopNewsCollectionViewCell : UICollectionViewCell {
    
    let mainView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xfafafa)
        return view
        
    }()
    
    let subView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xfafafa)
        return view
        
    }()
    
    let graView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let newsImage : UIImageView = {
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        
        
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.semibold)
        label.textColor = UIColor(rgb: 0xffffff)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // sıfır kısıtlama olmaması demek, satır sayısını kıstlamaz sınırsız satır olabilir demek gibi bişey
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(model: ArticleNewsModelElement){
        let imageURL = URL(string: model.files[0].fileURL)!
        newsImage.kf.setImage(with: imageURL)
        title.text = model.title
    }
    
    func setupUI(){
        addSubview(mainView)
        mainView.addSubview(subView)
        subView.addSubview(newsImage)
        subView.addSubview(graView)
        subView.addSubview(title)
        
        
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        subView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        title.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        graView.snp.makeConstraints { (make) in
            make.top.equalTo(subView.snp.centerY)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        newsImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = graView.bounds
        gradient.colors = [ UIColor.clear.withAlphaComponent(0.0).cgColor, UIColor(rgb: 0x000000).withAlphaComponent(0.4).cgColor, UIColor(rgb: 0x000000).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        graView.layer.insertSublayer(gradient, at: 0)
        graView.alpha = 0.7
        
        newsImage.clipsToBounds = true
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 12.0
        
    }
    
    
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(rgb: 0xfafafa).cgColor
        let colorBottom = UIColor(rgb: 0x000000).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
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
