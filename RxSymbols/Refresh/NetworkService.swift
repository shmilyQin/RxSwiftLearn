//
//  NetworkService.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/9.
//

import RxSwift
import RxCocoa
 
//网络请求服务
class NetworkService {
     
    //获取随机数据
    func getRandomResult() -> Driver<[String]> {
        print("正在请求数据......")
        let items = (0 ..< 15).map {_ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable
            .delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
