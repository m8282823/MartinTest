//
//  HeaderRecommonendView.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit

class HeaderRecommonendView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var titleLabel: UILabel
    var collectionView: UICollectionView
    let reuseIdentfier = "reuseIdentfier"
    public static let height: CGFloat = 170.0
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override init(frame: CGRect) {
        self.titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height: 30)))
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: titleLabel.frame.maxY + 20), size: CGSize(width: frame.size.width, height: 120)), collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
        backgroundColor = .white
    }
    
    func setupUI() {
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.text = "推介";
        addSubview(titleLabel)
        
        collectionView.backgroundColor = .white
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: reuseIdentfier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentfier, for: indexPath)
//        if (cell != nil) {
//            cell = RecommendCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 120)))
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

}
