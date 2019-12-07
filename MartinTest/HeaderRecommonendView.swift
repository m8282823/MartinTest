//
//  HeaderRecommonendView.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit

class HeaderRecommonendView: UIView {
    
    let titleLabel = UILabel()
    var collectionView: UICollectionView
    
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    func setupUI() {
        titleLabel.frame = CGRect(origin: CGPoint(x: 10, y: 20), size: CGSize(width: 100, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.text = "推介";
        addSubview(titleLabel)
        
        let layout = UICollectionViewLayout.init()
        
        collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: titleLabel.frame.maxY + 20), size: CGSize(width: frame.size.width, height: 100)), collectionViewLayout: layout)
    }
    
    

}
