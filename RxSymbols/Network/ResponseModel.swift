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
    let data: Data?
    var arrayData:[[String : Any]] = []
    var dictData: [String : Any] = [:]
    var jsonString = ""
    init(_ data: Data) {
        
        self.data = data
        
        let allDic = (try? JSON.init(data: data).dictionaryObject) ?? [:]
        
        let dict = allDic["result"] as? Dictionary<String, Any> ?? [:]
        
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
        
        let tempArray = dict["data"] as? [[String : Any]]
        if tempArray != nil {
            arrayData = tempArray!
        }
        
        let tempDict = dict["data"] as? [String : Any]
        if tempDict != nil {
            dictData = tempDict!
        }
    }
    
    fileprivate func getInnerObject(inside object: Any?, by designatedPath: String?) -> Any? {
        var result: Any? = object
        var abort = false
        if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
            var next = object as? [String: Any]
            paths.forEach({ (seg) in
                if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
                    return
                }
                if let _next = next?[seg] {
                    result = _next
                    next = _next as? [String: Any]
                } else {
                    abort = true
                }
            })
        }
        return abort ? nil : result
    }
}

// HandyJson
extension ResponseModel{
    fileprivate func mapModel<T: HandyJSON>(_ type:T.Type,designatedPath:String?) -> T?{
        return T.deserialize(from: self.jsonString, designatedPath: designatedPath)
    }
    fileprivate func mapArrayModel<T:HandyJSON>(_ type:T.Type,designatedPath:String? ) -> [T]{
        return [T].deserialize(from: jsonString, designatedPath: designatedPath) as? [T] ?? []
    }
}

// HandyJson
extension PrimitiveSequence where Trait == SingleTrait,Element == ResponseModel {
    func mapMode<T: HandyJSON>(_ type:T.Type, designatedPath:String? = "result.data") -> Single<T>{
        return flatMap { response -> Single<T> in
            if let value = response.mapModel(T.self, designatedPath: designatedPath){
                return Single.just(value)
            }
            return Single.error(NetworkError.parseError)
        }
    }
    
    func mapArrayModel<T:HandyJSON>(_ type: T.Type, designatedPath:String? = "result.data") -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(response.mapArrayModel(T.self, designatedPath: designatedPath))
        }
    }
}

// Decodable
extension ResponseModel {
    
    fileprivate func getObject(by designatedPath: String) -> Data? {
        guard let jsonData = data else { return nil }
        let allDic = (try? JSON.init(data: jsonData).dictionaryObject) ?? [:]
        let dic = self.getInnerObject(inside: allDic, by: designatedPath)
        guard let target = dic else { return nil }
        return try? JSONSerialization.data(withJSONObject: target)
    }
    
    fileprivate func mapModel<T: Decodable>(type: T.Type, designatedPath: String? = nil) -> T? {
        guard let jsonData = data else { return nil }
        if let path = designatedPath {
            guard let pathData = getObject(by: path) else { return nil }
            return try? JSONDecoder().decode(T.self, from: pathData)
        } else {
            return try? JSONDecoder().decode(T.self, from: jsonData)
        }
        
    }
}

// Decodable
extension PrimitiveSequence where Trait == SingleTrait, Element == ResponseModel {
    func mapModel<T: Decodable>(type: T.Type, designatedPath: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            if let value = response.mapModel(type: T.self, designatedPath: designatedPath) {
                return Single.just(value)
            }
            return Single.error(NetworkError.parseError)
        }
    }
}


