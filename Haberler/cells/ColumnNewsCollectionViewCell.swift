//
//  ColumnNewsCollectionViewCell.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit



class ColumnNewsCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var columnNews: ColumnModelElement?{
        didSet{
            title.text = columnNews?.title
            desc.text = columnNews?.description
            name.text = columnNews?.fullname
            if (columnNews?.files.count)! > 0 {
                let imageURL = URL(string: columnNews!.files[0].fileURL)!
                imageView.kf.setImage(with: imageURL)
            }else{
                imageView.tintColor = UIColor.white
                imageView.image = UIImage(named: "person")
            }
            
        }
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = UIColor(rgb: 0xa0a0a0)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 16)
        label.textColor = UIColor(rgb: 0x323232)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
        
    }()
    
    let desc: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-Semibold", size: 14)
        label.textColor = UIColor(rgb: 0x797979)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 14)
        label.textColor = UIColor(rgb: 0xc54545)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    func setupUI(){
        addSubview(imageView)
        addSubview(title)
        addSubview(desc)
        addSubview(name)
        
        
        imageView.layer.cornerRadius = 12.0
        imageView.layer.masksToBounds = true
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            
        }
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.left.equalTo(title.snp.left)
            make.right.equalTo(title.snp.right)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.left)
            make.right.equalTo(title.snp.right)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        
        
        
        
        
        
        
    }
    
    
    
}
