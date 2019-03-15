//
//  GalleryController.swift
//  Haberler
//
//  Created by macbook  on 14.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class GalleryController: UICollectionViewController,
UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        collectionView.backgroundColor = UIColor.white
        self.tabBarController?.delegate = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        self.title = "Haber Galerisi"
        getGalleryNews()
    }
    private var selectingCount:Int = 0
    private var alreadyRoot:Bool = true //singleton
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 1 {
            selectingCount += 1
            
            if alreadyRoot{
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                alreadyRoot = false
                return
            }
            
            if selectingCount > 1{
                if tabBarController.selectedViewController?.navigationItem.title == "Haber Galerisi"{
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
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.width * 1 / 2 + 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! GalleryCollectionViewCell
        cell.model = self.galleryNews[indexPath.item]
        return cell
    }
    
    private let disposeBag = DisposeBag()
    var galleryNews:[GalleryModelElement] = []
    
    func getGalleryNews(){
        ApiClient.getGalleryNews()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (galleryNews) in
                self.galleryNews = galleryNews.filter({ (element) -> Bool in
                    element.files.count > 5
                })
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
            },
               onCompleted: {
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    
    
}

class GalleryCollectionViewCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: GalleryModelElement?{
        didSet{
            let imageURL = URL(string: (model?.files[0].fileURL)!)!
            let url2 = URL(string: (model?.files[1].fileURL)!)!
            let url3 = URL(string: (model?.files[2].fileURL)!)!
            let url4 = URL(string: (model?.files[3].fileURL)!)!
            let url5 = URL(string: (model?.files[4].fileURL)!)!
            
            bigImage.kf.setImage(with: imageURL)
            iv1.kf.setImage(with: url2)
            iv2.kf.setImage(with: url3)
            iv3.kf.setImage(with: url4)
            iv4.kf.setImage(with: url5)
            title.text = model?.title
            
            photoCountLabel.text = "+ \(model?.files.count ?? 0)"
            
            
        }
    }
    
    
    let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackV: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 1.0
        return stackview
    }()
    
    let stackV1: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 1.0
        return stackview
    }()
    let stackVc1: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 1.0
        return stackview
    }()
    let stackVc2: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 1.0
        return stackview
    }()
    
    let bigImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let iv1: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let iv2: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let iv3: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let iv4: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xd9d9d9)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 18)
        label.textColor = UIColor(rgb: 0x323232)
        label.text = "Yepyeni Bir İçerik Sizleri Bekliyor"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
        
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let photoCountLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 22)
        label.textColor = UIColor(rgb: 0xffffff)
        label.text = "+5"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
        
    }()
    
    
    
    
    func setupUI(){
        
        addSubview(mainView)
        addSubview(bottomView)
        bottomView.addSubview(title)
        mainView.addSubview(stackV)
        stackV.addArrangedSubview(bigImage)
        stackV.addArrangedSubview(stackV1)
        stackV1.addArrangedSubview(stackVc1)
        stackV1.addArrangedSubview(stackVc2)
        stackVc1.addArrangedSubview(iv1)
        stackVc1.addArrangedSubview(iv2)
        stackVc2.addArrangedSubview(iv3)
        stackVc2.addArrangedSubview(conView)
        conView.addSubview(iv4)
        conView.addSubview(blackView)
        conView.addSubview(photoCountLabel)
        
        
        
        iv4.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        blackView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        photoCountLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(mainView.snp.width).multipliedBy(0.5)
        }
        
        stackV.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            
        }
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        bigImage.layer.masksToBounds = true
        iv1.layer.masksToBounds = true
        iv2.layer.masksToBounds = true
        iv3.layer.masksToBounds = true
        iv4.layer.masksToBounds = true
        
        mainView.layer.cornerRadius = 12.0
        mainView.layer.masksToBounds = true
        
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        
    }
    
    
}
