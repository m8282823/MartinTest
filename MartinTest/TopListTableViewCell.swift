//
//  TopListTableViewCell.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import SwiftyJSON

class TopListTableViewCell: UITableViewCell {
    
    let indexLabel = UILabel()
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    let scoreLabel = UILabel()
    let request = Network()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        makeConstraint()
        
    }
    
    func setupUI() {
        indexLabel.font = UIFont.systemFont(ofSize: 15)
        indexLabel.textColor = .lightGray
        contentView.addSubview(indexLabel)
        
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        typeLabel.font = UIFont.systemFont(ofSize: 13)
        typeLabel.textColor = .lightGray
        contentView.addSubview(typeLabel)
        
        scoreLabel.font = UIFont.systemFont(ofSize: 12)
        scoreLabel.textColor = .lightGray
        contentView.addSubview(scoreLabel)
    }
    
    func makeConstraint() {
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(iconImageView.snp.top).offset(5)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        scoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateData(model: TopListModel, score: ScoreModel) {
        indexLabel.text = model.index;
        iconImageView.kf.setImage(with: URL(string: model.iconImageUrlString))
        nameLabel.text = model.nameString
        typeLabel.text = model.typeString
        
        if (Int(model.index)! % 2 == 0) {
            iconImageView.layer.cornerRadius = 35
        } else {
            iconImageView.layer.cornerRadius = 10
        }
        if score.scoreString.count > 0 && score.countString.count > 0 {
            self.scoreLabel.text = "\(String(describing: score.scoreString))(\(String(describing: score.countString)))"
            return
        }
        
        request.requestLookupApp(appid: model.idString) {[weak self] (success, result) in
            if success == .success {
                let idData = result as! JSON
                let dictionary = idData["results"].array?.first?.dictionary
                let averageRating = dictionary?["averageUserRating"]?.number?.stringValue ?? ""
                let ratingCount = dictionary?["userRatingCount"]?.number?.stringValue ?? ""
                if averageRating.count > 0 && ratingCount.count > 0 {
                    self?.scoreLabel.text = "\(String(describing: averageRating))(\(String(describing: ratingCount)))"
                    score.scoreString = averageRating
                    score.countString = ratingCount
                }
            }
        }
    }
    
}
