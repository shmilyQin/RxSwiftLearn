//
//  API.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import Foundation
import Moya
let APPKEY = "eedbe46fed2fbaccf5a3dd61f97fcbb2"
let lyApiProvider = MoyaProvider<LYApi>()
enum LYApi {
    case news_detail(type:String)
}
extension LYApi:TargetType{
    var baseURL: URL {
        return URL.init(string: "http://v.juhe.cn/")!
    }
    
    var path: String {
        return "toutiao/index"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .news_detail(let type):
            return .requestParameters(parameters: ["key":APPKEY,"type":type], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
