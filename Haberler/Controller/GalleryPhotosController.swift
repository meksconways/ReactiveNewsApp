//
//  GalleryPhotosController.swift
//  Haberler
//
//  Created by macbook  on 18.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
class GalleryPhotosController: UICollectionViewController,
UICollectionViewDelegateFlowLayout{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(rgb: 0x212121)
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        self.title = "Galeri"
        
        let backButton = UIBarButtonItem()
        collectionView.contentInsetAdjustmentBehavior = .never
        //self.automaticallyAdjustsScrollViewInsets = false
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x212121)
        setTabBarHidden(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        setTabBarHidden(false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PhotosCell
        let first = self.indexArr[indexPath.item]
        let last = self.indexArr.last
        cell.indexInfo = [first,last] as? [Int]
        if let mModel = self.model?[indexPath.item]{
            cell.files = mModel
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = model?.count{
            return count
        }
        return 0
        
    }
    var model:[FileY]?{
        didSet{
            self.collectionView.reloadData()
            if let count = model?.count{
                createIndexArray(count: count)
            }
        }
    }
    
    var indexArr:[Int] = []
    
    func createIndexArray(count: Int){
        for i in 1...count{
            indexArr.append(i)
        }
    }
}

class PhotosCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var indexInfo:[Int]?{
        didSet{
            countLabel.text = "\(indexInfo![0]) / \(indexInfo![1])"
        }
    }
    
    
    var files:FileY?{
        didSet{
            if let url = files?.fileURL{
                let imageUrl = URL(string: url)
                imageView.kf.setImage(with: imageUrl)
            }
            if let description = files?.metadata.description{
                desc.text = description.html2String
            }
        }
    }
    
    let imageView:UIImageView = {
      let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.backgroundColor = UIColor(rgb: 0x212121)
        return imageV
    }()
    
    let scrollV:UIScrollView = {
       let scrollV = UIScrollView()
        scrollV.translatesAutoresizingMaskIntoConstraints = false
        return scrollV
    }()
    
    
    let containerView : UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let desc: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 16)
        label.textColor = UIColor(rgb: 0xffffff)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        return label
        
    }()
    
    let countLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 15)
        label.textColor = UIColor(rgb: 0xffffff)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
        
    }()
    
    func setupUI(){
        addSubview(imageView)
        addSubview(scrollV)
        scrollV.addSubview(containerView)
        containerView.addSubview(desc)
        addSubview(countLabel)
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.6)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            
        }
        
        scrollV.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview() // todo
        }
        desc.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview() // todo
        }
    }
    
}
