//
//  ColumnDetailController.swift
//  Haberler
//
//  Created by macbook  on 18.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import SnapKit
class ColumnDetailController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = writerName
        tableView.backgroundColor = UIColor.white
        tableView.register(ColumnDetailCell.self, forCellReuseIdentifier: "cellid")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        getDetail()
        
    }
    var writerName: String!
    var newsId: String!
    var detailModel: ColumnDetailModel?
    let disposeBag = DisposeBag()
    func getDetail(){
        ApiClient.getColumnDetail(newsId: newsId)
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (detail) in
                self.detailModel = detail
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
                self.tableView.reloadData()
            })
        .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! ColumnDetailCell
        if let mModel = self.detailModel{
            cell.model = mModel
        }
        return cell
    }

}

class ColumnDetailCell: BaseCell{
    
    
    
    var model:ColumnDetailModel?{
        didSet{
            
//            if (model?.files.count)! > 0 {
//                let imageURL = URL(string: model!.files[0].fileURL)!
//                writerImage.kf.setImage(with: imageURL)
//            }else{
//                
//                writerImage.image = UIImage(named: "writerplaceholder")
//            }
            
            if let files = model?.files{
                if files.count > 0{
                    let url = URL(string: files[0].fileURL)
                    writerImage.kf.setImage(with: url)
                }else{
                    writerImage.image = UIImage(named: "writerplaceholder")
                }
            }
            writerName.text = model?.fullname
            title.text = model?.title
            desc.text = model?.description
            if let longText = model?.text{
                detailText.text = longText.html2String
            }
            
            if let startDate = model?.createdDate{
                let inputFormatter = DateFormatter()
                inputFormatter.locale = Locale(identifier: "tr_TR_POSIX")
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                guard let showDate = inputFormatter.date(from: startDate)else{return} //2019-03-16T20:58:54.906Z
                inputFormatter.dateFormat = "EEEE, d MMMM yyyy HH:mm"
                let resultString = inputFormatter.string(from: showDate)
                dateLabel.text = resultString
            }
        }
    }
    
    let writerImage:UIImageView = {
       let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.backgroundColor = UIColor(rgb: 0xd9d9d9)
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    let writerName:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-Bold", size: 20)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xd9d9d9)
        return view
    }()
    
    let title:UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Dosis-Bold", size: 22)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 14)
        label.textColor = UIColor(rgb: 0x797979)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let desc:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-Bold", size: 16)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailText:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 15)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func setupUI() {
        super.setupUI()
        addSubview(writerImage)
        addSubview(writerName)
        addSubview(dividerView)
        addSubview(title)
        addSubview(dateLabel)
        addSubview(desc)
        addSubview(detailText)
        
        writerImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(52)
            make.height.equalTo(writerImage.snp.width)
        }
        writerName.snp.makeConstraints { (make) in
            make.centerY.equalTo(writerImage.snp.centerY)
            make.left.equalTo(writerImage.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        dividerView.snp.makeConstraints { (make) in
            make.top.equalTo(writerImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(52 + 16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(dividerView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
        detailText.snp.makeConstraints { (make) in
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        writerImage.layer.cornerRadius = 26.0
        writerImage.layer.masksToBounds = true
        writerImage.layer.borderColor = UIColor.white.cgColor
        writerImage.layer.borderWidth = 1.0
        writerImage.clipsToBounds = true
        
        
        
        
    }
    
}
