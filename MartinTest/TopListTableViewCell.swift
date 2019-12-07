//
//  TopListTableViewCell.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import SnapKit

class TopListTableViewCell: UITableViewCell {
    
    let indexLabel = UILabel()
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    let scoreLabel = UILabel()
    
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
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
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
            make.left.equalTo(contentView.snp_leftMargin).offset(10)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp_rightMargin).offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_rightMargin).offset(10)
            make.top.equalTo(iconImageView.snp_topMargin).offset(5)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_leftMargin)
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(5)
        }
        
        scoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_leftMargin)
            make.top.equalTo(typeLabel.snp_bottomMargin).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateData(model: TopListModel) {
        
    }
    
}
