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
class NewsDetailController: UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HeaderCell.self, forCellReuseIdentifier: "headerid")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "titleid")
        tableView.register(BodyCell.self, forCellReuseIdentifier: "bodyid")
        self.title = "Haber Detay"
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 60,right: 0)
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor.white
        activityView.center = self.view.center
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(activityView)
        getNewsDetail()
    }
    let activityView = UIActivityIndicatorView(style: .gray)
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarHidden(false)

        
    }
    
    private let disposeBag = DisposeBag()
    var newsDetailModel: NewsDetailModel?
    
    
    
    func getNewsDetail(){
        
        ApiClient.getNewsDetail(newsId: newsId!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newsDetail) in
                self?.newsDetailModel = newsDetail
            }, onError: { (error) in
                // todo sc
            }, onCompleted: {
                self.tableView.reloadData()
                self.activityView.stopAnimating()
                
            })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleid", for: indexPath) as! TitleCell
            cell.titleModel = self.newsDetailModel
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerid", for: indexPath) as! HeaderCell
            cell.model = self.newsDetailModel
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bodyid", for: indexPath) as! BodyCell
            cell.model = self.newsDetailModel
            return cell
        }
    }
    
    var newsId: String?
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

class BodyCell : BaseCell {
    
    
    let desc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-SemiBold", size: 16)
        label.textColor = UIColor(rgb: 0x323232)
        label.numberOfLines = 0
        return label
    }()
    
    let halfTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-Bold", size: 18)
        label.textColor = UIColor(rgb: 0x323232)
        label.numberOfLines = 0
        return label
    }()
    
    var model:NewsDetailModel?{
        didSet{
            if let halfText = model?.description{
                halfTitle.text = halfText
            }
            if let description = model?.text{
                desc.text = description.html2String
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        addSubview(desc)
        addSubview(halfTitle)
        
        halfTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(halfTitle.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            
        }
    }
}

class TitleCell: BaseCell {
    
    
    
    var titleModel: NewsDetailModel?{
        didSet{
            
            title.text = titleModel?.title
            
            if let startDate = titleModel?.createdDate{
                let inputFormatter = DateFormatter()
                inputFormatter.locale = Locale(identifier: "tr_TR_POSIX")
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let showDate = inputFormatter.date(from: startDate) //2019-03-16T20:58:54.906Z
                inputFormatter.dateFormat = "E, d MMM yyyy HH:mm"
                let resultString = inputFormatter.string(from: showDate!)
                dateLabel.text = resultString
            }
        }
        
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-Bold", size: 22)
        label.text = "Haberlerde BuGün\nmerhaba"
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Dosis-SemiBold", size: 14)
        label.textColor = UIColor(rgb: 0x515151)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    
    
    override func setupUI() {
        super.setupUI()
        
        addSubview(title)
        
        addSubview(dateLabel)
        
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
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
        return CGSize(width: self.bounds.width, height: 220)
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
        collectionView.backgroundColor = UIColor.white
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
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(220)
        }
        pageController.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }
    }
}

class NewsDetailHeaderPhotoCollectionViewCell : UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    
    func setupUI() {
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
    }
    
}

class BaseCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
    }
    
}
