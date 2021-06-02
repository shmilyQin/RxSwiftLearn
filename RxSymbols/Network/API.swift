//
//  API.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import Foundation
import Moya
let APPKEY = "eedbe46fed2fbaccf5a3dd61f97fcbb2"
let WEATHERKEY = "ed55a40552feac349c5ff63353ba6311"
let lyApiProvider = MoyaProvider<LYApi>()
enum LYApi {
  case news_detail(type:String)
  case getWeather
  case Home(HomeApi)
}
extension LYApi:TargetType{
  var baseURL: URL {
    switch self {
    case .news_detail:
      return URL.init(string: "http://v.juhe.cn/")!
    case .getWeather:
      return URL.init(string: "http://apis.juhe.cn/")!
    default:
      return URL.init(string: "http://apis.juhe.cn/")!
    }
   
  }
  
  var path: String {
    switch self {
    case .news_detail:
      return "toutiao/index"
    case .getWeather:
      return "simpleWeather/query"
    case .Home(let home):
      return home.path
    }
   
  }
  
  var method: Moya.Method {
    switch self {
    case .Home(let home):
      return home.method
    default:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .news_detail(let type):
      return .requestParameters(parameters: ["key":APPKEY,"type":type], encoding: URLEncoding.default)
    case .getWeather:
      return .requestParameters(parameters: ["key":WEATHERKEY,"city":"6"], encoding: URLEncoding.default)
    case .Home(let home):
      return home.task
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}
