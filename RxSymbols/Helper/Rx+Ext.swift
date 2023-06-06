//
//  Rx+Ext.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import ProgressHUD
struct ResponseError:Error {
    var desc = ""
    init(_ desc:String) {
        self.desc = desc
    }
}
extension Reactive where Base:MoyaProviderType{
    func LYRequest(_ api: Base.Target, callbackQueue: DispatchQueue? = nil , showHub:Bool = true,showResultHub:Bool = true) -> Single<ResponseModel> {
        return Single.create { [weak base] single -> Disposable in
            print("-----------------------------------------------")
            print(api.path)
            if showHub{
                ProgressHUD.show("加载中...")
            }
            let cancellableToken = base?.request(api, callbackQueue: callbackQueue, progress: nil, completion: { (result) in
                ProgressHUD.dismiss()
                switch result {
                case let .success(response):
                        print("-----------------------------------------------")
                        print(try? JSON.init(data: response.data))
                        print("-----------------------------------------------")
                    let model = ResponseModel.init(response.data)
                    if model.status == 401{
                        single(.failure(ResponseError(model.msg)))
                    }else if model.status == 0{
                        single(.success(model))
                    }else{
                        single(.failure(ResponseError(model.msg)))
                    }
                case let .failure(error):
                    print("错误状态码:\((error.response?.statusCode ?? 0))")
                    single(.failure(ResponseError("无法链接")))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
