//
//  RecommendCell.swift
//  MartinTest
//
//  Created by martin on 2019/12/8.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class RecommendCell: UICollectionViewCell {
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        typeLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .gray
        contentView.addSubview(typeLabel)
    }
    
    func makeConstraint() {
        iconImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(iconImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.left.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
        }
    }
    
    func refreshData(model: RecommendModel) {
        iconImageView.kf.setImage(with: URL(string: model.iconImageUrlString))
        nameLabel.text = model.nameString
        typeLabel.text = model.typeString
    }
    
}
