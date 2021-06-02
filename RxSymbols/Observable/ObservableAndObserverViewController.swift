//
//  ObservableAndObserverViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/31.
//

import UIKit
class ObservableAndObserverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        asyncSubjectSignal()
//        publishSubject()
//        replaySubject()
//        behaviorSubject()
    }
}
//MARK:-----AsyncSubject-----
extension ObservableAndObserverViewController{
//    源Observable产生完成事件后,就只发出最后一个元素,仅仅是最后一个元素,如果没有发出元素就发出一个完成事件
    func asyncSubjectSignal(){
        let asyncOb = AsyncSubject<Int>()
        asyncOb.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
        
        asyncOb.onNext(1)
        asyncOb.onNext(2)
        asyncOb.onNext(3)
        asyncOb.onCompleted()
    }

}
//MARK:-----PublishSubject-----
extension ObservableAndObserverViewController{
//    将会对观察者发出订阅后的元素,订阅前产生的元素不会发送给观察者.
//    PublishRelay 是PublishSubject去掉终止事件 onError或者Oncompleted
    func publishSubject(){
        let publishOB = PublishSubject<String>()
        publishOB.subscribe(onNext: { (content) in
            print("第一次订阅的"+content)
        }).disposed(by: disposeBag)
        publishOB.onNext("第1次发送")
        publishOB.onNext("第2次发送")
        publishOB.subscribe(onNext: { (content) in
            print("第二次订阅的"+content)
        }).disposed(by: disposeBag)
        publishOB.onNext("第3次发送")
        publishOB.onNext("第4次发送")
    }
}
//MARK:-----ReplaySubject-----
extension ObservableAndObserverViewController{
//    对观察者发送全部元素,无论是何时订阅
//    创建的时候需要设置一个size 表示缓存个数(缓存最近的n个)
//    对于已经订阅了的 就只会发出next 元素  如果新订阅的就会发出缓存的元素
//    发出的元素会重新进缓存
    func replaySubject(){
        let replaySubjectOB = ReplaySubject<String>.create(bufferSize: 2)
        //连续发送3个next事件
        replaySubjectOB.onNext("1")
        replaySubjectOB.onNext("2")
        replaySubjectOB.onNext("3")
        replaySubjectOB.subscribe({ (event) in
//            这里会先收到2 3
//            接着会收到下面发出的元素
            print("第一次订阅",event)
        }).disposed(by: disposeBag)
        replaySubjectOB.onNext("4") //这里发出元素后,Observable最新的元素为 3 4
//        replaySubjectOB.onNext("5")
//        第二次订阅
        replaySubjectOB.subscribe({ (event) in
//            这里会先收到3 4
//            接着会收到下面发出的元素
            print("第二次订阅",event)
        }).disposed(by: disposeBag)
        replaySubjectOB.onCompleted()
        //第3次订阅subject
        replaySubjectOB.subscribe { event in
            print("第三次订阅：", event)
        }.disposed(by: disposeBag)
    }
}
//MARK:-----BehaviorSubject-----
extension ObservableAndObserverViewController{
    //    BehaviorRelay 是BehaviorSubject去掉终止事件 onError或者Oncompleted

    func behaviorSubject(){
//        当观察者仅进行订阅的时候,会把Observable中最新的元素发出来,如果没有就发出初始化的时候设置的默认元素
        let behaviorSubjectOb = BehaviorSubject(value: "默认元素")
        behaviorSubjectOb.subscribe(onNext: { (content) in
//            这里刚开始会收到"默认元素" 因为针对Obervable来说,没有发出过元素,所以就发出默认元素,也可以理解为Observable最新的元素
//            接着会收到下面发出的元素
            print("第一次订阅"+content)
        }).disposed(by: disposeBag)
        behaviorSubjectOb.onNext("第一次")
        behaviorSubjectOb.onNext("第二次")
        behaviorSubjectOb.subscribe(onNext: { (content) in
//            这里刚开始会收到"第二次" 因为针对Obervable来说,"第二次"是最新的元素
//            接着会收到下面发出的元素
            print("第二次订阅"+content)
        }).disposed(by: disposeBag)
        behaviorSubjectOb.onNext("第三次")
        behaviorSubjectOb.subscribe(onNext: { (content) in
//            这里刚开始会收到"第三次" 因为针对Obervable来说,"第三次"是最新的元素
//            接着会收到下面发出的元素
            print("第三次订阅"+content)
        }).disposed(by: disposeBag)
    }
}


