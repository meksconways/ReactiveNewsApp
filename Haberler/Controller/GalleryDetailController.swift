//
//  GalleryDetailController.swift
//  Haberler
//
//  Created by macbook  on 18.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
class GalleryDetailController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Haber Detay"
        tableView.backgroundColor = UIColor.white
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        tableView.register(GalleryDetailHeaderCell.self, forCellReuseIdentifier: "headerid")
        tableView.register(GalleryDetailMiddleCell.self, forCellReuseIdentifier: "middleid")
        tableView.separatorStyle = .none
        
    }
    
    func showGalleryGrid(files: [FileY]){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let controller = GalleryPhotosController(collectionViewLayout: layout)
        controller.model = files
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerid", for: indexPath) as! GalleryDetailHeaderCell
            cell.model = self.galleryModel
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "middleid", for: indexPath) as! GalleryDetailMiddleCell
            cell.model = self.galleryModel
            cell.controller = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    var galleryModel:GalleryModelElement?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    
}

class GalleryDetailHeaderCell: BaseCell{
    
    var model:GalleryModelElement?{
        didSet{
            title.text = model?.title
            if let startDate = model?.createdDate{
                let inputFormatter = DateFormatter()
                inputFormatter.locale = Locale(identifier: "tr_TR_POSIX")
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                guard let showDate = inputFormatter.date(from: startDate)else{return} //2019-03-16T20:58:54.906Z
                inputFormatter.dateFormat = "E, d MMM yyyy HH:mm"
                let resultString = inputFormatter.string(from: showDate)
                dateLabel.text = resultString
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        addSubview(title)
        addSubview(dateLabel)
        
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    let title:UILabel = {
       let label = UILabel()
        label.textColor = UIColor(rgb: 0x212121)
        label.font = UIFont(name: "Dosis-Bold", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x797979)
        label.font = UIFont(name: "Dosis-SemiBold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let editorLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x797979)
        label.font = UIFont(name: "Dosis-SemiBold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
}

class GalleryDetailMiddleCell: BaseCell{
   
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
            title.text = model?.description
            
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
        label.font = UIFont(name: "Dosis-SemiBold", size: 16)
        label.textColor = UIColor(rgb: 0x323232)
        label.text = "Yepyeni Bir İçerik Sizleri Bekliyor"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
    
    let goGalleyBtn: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Galeriye Git >", for: UIControl.State.normal)
        button.titleLabel?.font =  UIFont(name: "Dosis-Bold", size: 16)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(rgb: 0xc54545), for: UIControl.State.normal)
        return button
    }()
    
    var controller: GalleryDetailController?
    override func setupUI(){
        super.setupUI()
        addSubview(mainView)
        addSubview(bottomView)
        bottomView.addSubview(title)
        bottomView.addSubview(goGalleyBtn)
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
        
        goGalleyBtn.addTapGestureRecognizer {
            if let files = self.model?.files{
                self.controller?.showGalleryGrid(files: files)
            }
        }
        
        
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
            make.bottom.equalToSuperview()
            
        }
        
        goGalleyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(120)
        }
        
    }
    
    
}
