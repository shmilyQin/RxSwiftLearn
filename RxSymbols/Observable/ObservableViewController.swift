//
//  ObservableViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/30.
//

import UIKit
import RxSwift
class ObservableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservable()
    }
    func subscribeAction<T>(ob:Observable<T>) {
        ob.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
    }
   
}
//MARK:-----Observable-----
extension ObservableViewController{
    func createObservable() {
//        Observable的创建的几种方式
        let justOB = Observable<Int>.just(1)
//        subscribeAction(ob: justOB)
//        该方法可以接受可变数量的参数（必需要是同类型的）
        let of = Observable.of("这是of")
//        from接收一个数参数 最终效果和of是一样的
        let from = Observable.from([1,2,3])
//        subscribeAction(ob: from)
//        empty 创建一个空序列会执行completed的闭包
        let emptyOB = Observable<Int>.empty()
//        subscribeAction(ob: emptyOB)
//        error 直接发出一个错误的序列 会执行error闭包
        let errorOB = Observable<Int>.error(NSError.init())
//        range 该方法通过指定起始和结束数值,创建一个这个范围内的序列
        let rangeOB = Observable.range(start: 1, count: 5)
//        subscribeAction(ob: rangeOB)
//        repeatElement 无限发出指定元素 不会终止
        let repeatOB = Observable.repeatElement("repeat")
//        subscribeAction(ob: repeatOB)
//        generate 创建一个当提供所有的判断为true的时候
//        initialState 初始值 condition条件 iterate迭代器
        let generateOB =  Observable<Int>.generate(initialState: 0, condition:{$0 <= 10}, iterate: {$0+2})
        
//        create 自定义序列创建
        let createOB = Observable<String>.create{observer in
            //对订阅者发出了.next事件
            observer.onNext("whs=>我好帅")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //也可以发出error事件
//            observer.onError(<#T##error: Error##Error#>)
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
//        interval 这个方法创建的 Observable 序列每隔一段设定的时间,会发出一个索引数的元素
        let intervalOB = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//        timer 第一种,创建一个序列在规定时间后发出,且产生唯一的元素
        let timerOne = Observable<Int>.timer(.seconds(4), scheduler: MainScheduler.init())
        subscribeAction(ob: timerOne)
//        timer 第二种,每隔一段时间产生一个元素
        let timerTwo = Observable<Int>.timer(.seconds(1), period: .seconds(2), scheduler: MainScheduler.init())
        
    }
}

