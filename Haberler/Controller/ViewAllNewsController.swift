//
//  ViewAllNewsController.swift
//  Haberler
//
//  Created by macbook  on 17.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import Alamofire
class ViewAllNewsController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ViewAllNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        self.title = pageTitle
        self.view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.center = self.view.center
        fetchNews()
    }
    
    let indicator = UIActivityIndicatorView(style: .gray)
    
    var pageTitle: String?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 16, right: -10)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ViewAllNewsCollectionViewCell
        cell.model = self.filteredNews[indexPath.item]
        return cell
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showNewsDetail(newsID: filteredNews[indexPath.item].id!)
    }
    
    func showNewsDetail(newsID:String) {
        
        let detailController = NewsDetailController()
        detailController.newsId = newsID
        self.navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    
    func fetchNews(){
        guard let k = keyword else{
            return
        }
        guard let url = URL(string: "https://api.hurriyet.com.tr/v1/search/\(k)")else{
            return
        }
        print(url)
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(Constants.API_KEY, forHTTPHeaderField: "apikey")
        
        let dataTask = URLSession.shared.dataTask(with: req){
            data, response, error in
            if error != nil {
                print("error = \(String(describing:error?.localizedDescription))")
            }
            guard let data = data else {
                
                return
            }
           
            do{
                
                let news = try JSONDecoder().decode(AllCategoriesModel.self, from: data)
                self.allNews = news
                
                DispatchQueue.main.async {
                    if let list = self.allNews?.list{
                        self.filteredNews = list.filter({ (element) -> Bool in
                            ((element.files?.count)! > 0 && element.contentType == "Article")
                        })
                    }
                    self.indicator.stopAnimating()
                    
                    
                    UIView.transition(with: self.collectionView,
                                      duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: { self.collectionView.reloadData() })
                    //self.collectionView.reloadData()
                }
                
            }
            catch let err{
                print("catch dustu \(err.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    
    var filteredNews: [List] = []
    var allNews: AllCategoriesModel?
    var keyword: String?
    
 
    
}
class ViewAllNewsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: List?{
        didSet{
            newsText.text = model?.title
            if let imageurl = model?.files?[0].fileUrl{
                let imageURL = URL(string: imageurl)!
                newsImage.kf.setImage(with: imageURL)
            }
            if let startDate = model?.modifiedDate{
                let inputFormatter = DateFormatter()
                inputFormatter.locale = Locale(identifier: "tr_TR_POSIX")
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //2019-08-17T16:12:48.188
                guard let showDate = inputFormatter.date(from: startDate)else{
                    return
                }
                inputFormatter.dateFormat = "EEEE, d MMMM yyyy HH:mm"
                let resultString = inputFormatter.string(from: showDate)
                dateLabel.text = resultString
            }
        }
    }
    
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-SemiBold", size: 12.0)
        label.numberOfLines = 3
        label.textColor = UIColor(rgb: 0x797979)
        return label
    }()
    
   
    
    func setupUI(){
        addSubview(newsImage)
        addSubview(newsText)
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
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
