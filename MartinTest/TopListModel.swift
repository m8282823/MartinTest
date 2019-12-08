//
//  TopListModel.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import Foundation
import SwiftyJSON

class TopListModel {
    
    
    var index: String
    var iconImageUrlString: String
    var nameString: String
    var typeString: String
    var scoreString: String
    
    
    init(index:Int, originalData: JSON) {
        self.index = "\(index)"
        
        typeString = originalData["category"]["attributes"]["label"].string ?? ""
        iconImageUrlString = originalData["im:image"].array?.last?["label"].string ?? ""
        nameString = originalData["im:name"]["label"].string ?? ""
        scoreString = ""
    }
}

class RecommendModel {
    var iconImageUrlString: String
    var nameString: String
    var typeString: String
    
    
    init(originalData: JSON) {
        iconImageUrlString = originalData["im:image"].array?.last?["label"].string ?? ""
        nameString = originalData["im:name"]["label"].string ?? ""
        typeString = originalData["category"]["attributes"]["label"].string ?? ""
    }
    
    
}



