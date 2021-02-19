//
//  ResponseModel.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import Foundation
import HandyJSON
import RxSwift
import SwiftyJSON
struct ResponseModel {
    
    var status: Int = 0
    var msg = ""
    var arrayData:[[String : Any]] = []
    var dictData: [String : Any] = [:]
    let data: Data
    var jsonString = ""
    init(_ data: Data) {
        
        self.data = data
        
        do {
            let allDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String, Any>
            let dict = allDic["result"] as! Dictionary<String, Any>
            let jsonString = JSON(data).description
            self.jsonString = jsonString
            let tempStatus = dict["error_code"] as? Int
            if tempStatus != nil {
                status = tempStatus!
            }
            
            let tempMessage = dict["reason"] as? String
            if tempMessage != nil {
                msg = tempMessage!
            }
            
            let tempArray = dict["data"] as? [[String : AnyObject]]
            if tempArray != nil {
                arrayData = tempArray!
            }
            
            let tempDict = dict["data"] as? [String : AnyObject]
            if tempDict != nil {
                dictData = tempDict!
            }
            
        } catch _ {
            print("数据解析错误")
        }

    }
}
extension ResponseModel{
    func mapMode<T:HandyJSON>(_ type:T.Type,designatedPath:String? = nil) -> T{
        if let path = designatedPath{
            return type.deserialize(from: self.jsonString, designatedPath: path)!
        }
        return type.deserialize(from: self.jsonString)!
    }
    func mapArrayModel<T:HandyJSON>(_ type:T.Type,designatedPath:String? = nil) -> [T]{
        if let path = designatedPath{
            if let array = [T].deserialize(from: jsonString, designatedPath: path) as? [T]{
                return array
            }
            return []
        }else{
            if let array = [T].deserialize(from: self.arrayData) as? [T]{
                return array
            }
            return []
        }
    }
}
extension PrimitiveSequence where Trait == SingleTrait,Element == ResponseModel{
    func mapMode<T:HandyJSON>(_ type:T.Type,designatedPath:String? = nil) ->Single<T>{
        return flatMap { response -> Single<T> in
            return Single.just(response.mapMode(T.self, designatedPath: designatedPath))
        }
    }
    func mapArrayModel<T:HandyJSON>(_ type: T.Type,designatedPath:String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(response.mapArrayModel(T.self, designatedPath: designatedPath))
        }
    }
}

