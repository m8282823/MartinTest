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

typealias CompleteResult = (Bool,Any) -> Void

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
            return "hk/rss/topfreeapplications/limit=10/json"
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
            self.handleData(handResult: result, completeResult: completeResult)
        }
    }
    
    func requestTopList(completeResult:@escaping CompleteResult) {
        let provider = MoyaProvider<Store>()
        let _ = provider.request(.topList) { (result) in
            self.handleData(handResult: result, completeResult: completeResult)
        }
    }
    
    func requestLookupApp(appid:String, completeResult:@escaping CompleteResult) {
        let provider = MoyaProvider<Store>()
        let _ = provider.request(.lookup(password: appid)) { (result) in
            self.handleData(handResult: result, completeResult: completeResult)
        }
    }
    
    func handleData(handResult: Result<Moya.Response, MoyaError>,completeResult:@escaping CompleteResult) {
        switch handResult {
            case let .success(response):
                do {
                    let mapJson = try response.mapJSON()
                    let json = JSON(mapJson)
                    
                    completeResult(true,json)
                } catch {
                    completeResult(false,response)
                }
                
        case let .failure(error):
            completeResult(false,error)
        }
    }
    
}


