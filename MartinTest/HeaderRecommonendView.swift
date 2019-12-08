//
//  HeaderRecommonendView.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class HeaderRecommonendView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var titleLabel: UILabel
    var collectionView: UICollectionView
    var isSearchMode = false
    
    
    
    let reuseIdentfier = "reuseIdentfier"
    public static let height: CGFloat = 220.0
    
    var recommendData : Array<JSON>? {
        didSet {
            collectionView.reloadData()
            if titleLabel.superview == nil {
                addSubview(titleLabel)
            }
        }
    }
    
    var searchData : Array<JSON>? = []
//    {
//        didSet {
//            if searchData != nil {
//                collectionView.reloadData()
//            }
//        }
//    }
    
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override init(frame: CGRect) {
        self.titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height: 30)))
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 10, height: 0)
        layout.footerReferenceSize = CGSize(width: 10, height: 0)
        layout.itemSize = CGSize(width: frame.size.width / 4.0, height: 170)
        layout.minimumLineSpacing = 20
        
        
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: titleLabel.frame.maxY + 20), size: CGSize(width: frame.size.width, height: 170)), collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
        backgroundColor = .white
    }
    
    func setupUI() {
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.text = "推介";
        
        
        collectionView.backgroundColor = .white
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: reuseIdentfier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false;
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentfier, for: indexPath) as! RecommendCell
//        if (cell != nil) {
//            cell = RecommendCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 120)))
//        }
        var cellData = recommendData?[indexPath.row] ?? JSON()
        
        if isSearchMode {
            cellData = searchData?[indexPath.row] ?? JSON()
        }
        
        let model = RecommendModel(originalData: cellData)
        cell.refreshData(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchMode {
            return searchData?.count ?? 0
        } else {
            return recommendData?.count ?? 0
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }

}
