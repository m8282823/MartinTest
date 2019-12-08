//
//  NetworkRequest.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Result
import YYCache

typealias CompleteResult = (FetchDataType,Any) -> Void

public enum FetchDataType {
    case success
    case failureData
    case failureNoData
}

public enum Store {
    case recommend
    case topList
    case lookup(password:String)
}

extension Store: TargetType {
    public var baseURL: URL {
        return URL(string:"https://itunes.apple.com/")!
    }
    
    public var path: String {
        switch self {
        case .topList:
            return "hk/rss/topfreeapplications/limit=100/json"
        case .recommend:
            return "hk/rss/topgrossingapplications/limit=10/json"
        case .lookup(_):
            return "hk/lookup"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
        
    }
    
    public var task: Task {
        switch self {
        case let .lookup(password):
            return .requestParameters(parameters: ["id":password], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: ["":""], encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

public class Network {
    
    
    func requestRecommend(completeResult:@escaping CompleteResult) {
        let provider = MoyaProvider<Store>()
        let _ = provider.request(.recommend) { (result) in
            self.handleData(storeKey: "recommend", handResult: result, completeResult: completeResult)
        }
    }
    
    func requestTopList(completeResult:@escaping CompleteResult) {
        let provider = MoyaProvider<Store>()
        let _ = provider.request(.topList) { (result) in
            self.handleData(storeKey: "topList", handResult: result, completeResult: completeResult)
        }
    }
    
    func requestLookupApp(appid:String, completeResult:@escaping CompleteResult) {
        let provider = MoyaProvider<Store>()
        let _ = provider.request(.lookup(password: appid)) { (result) in
            self.handleData(storeKey: "lookup", handResult: result, completeResult: completeResult)
        }
    }
    
    func handleData(storeKey: String,handResult: Result<Moya.Response, MoyaError>,completeResult:@escaping CompleteResult) {
        let cache = YYCache(name: "data")
        switch handResult {
            case let .success(response):
                do {
                    let mapJson = try response.mapJSON()
                    let json = JSON(mapJson)
                    cache?.setObject(mapJson as? NSCoding, forKey: storeKey)
                    completeResult(.success,json)
                } catch {
                    if let cacheData = cache?.object(forKey: storeKey) {
                        if storeKey == "lookup" {
                            completeResult(.failureNoData,response)
                        } else {
                            let json = JSON(cacheData)
                            completeResult(.failureData,json)
                        }
                    } else {
                        completeResult(.failureNoData,response)
                    }
                }
                
        case let .failure(error):
            if let cacheData = cache?.object(forKey: storeKey) {
                let json = JSON(cacheData)
                completeResult(.failureData,json)
            } else {
                completeResult(.failureNoData,error)
            }
            
        }
    }
    
}


