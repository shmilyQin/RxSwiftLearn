//
//  SingleSymbolViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/23.
//

import UIKit
import RxCocoa
import RxSwift
class SingleSymbolViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "单序列"
        materializeSymbol()
//        windowSymbol()
//        timeoutSymbol()
//        takeSymbol()
//        takeLast()
//        takeUntil()
//        takeWhile()
//        startWithSymbol()
//        skipSymbol()
//        skipUntilSymbol()
//        skipWhile()
//        shareSymbol()
//        scanSymbol()
//        retrySymbol()
//        retryWhenSymbol()
//        reduceSymbol()
//        mapSymbol()
//        groupBySymbol()
//        elementAtSymbol()
//        distinctUntilChangedSymbol()
//        noShakeSymbol()
//        bufferSymbol()
        
    }

}
//MARK:-----Materialize-----
extension SingleSymbolViewController{
    func materializeSymbol(){
        Observable.of(1, 2, 1)
            .materialize()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
//MARK:-----window-----
extension SingleSymbolViewController{
    func windowSymbol(){
//        不明了
        let subject = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        subject.window(timeSpan: .seconds(3), count: 2, scheduler: MainScheduler.instance).flatMap{$0}.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----timeout-----
extension SingleSymbolViewController{
    func timeoutSymbol(){
//        在规定时间内没有发出元素就发出一个错误的元素
        let subject = Observable<Int>.just(1).delay(.seconds(3), scheduler: MainScheduler.instance)
        subject.timeout(.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: { (number) in
            print(number)
        }, onError: { (error) in
            print(error)
            print("发出错误")
        }).disposed(by: disposeBag)
    }
}
//MARK:-----take-----
extension SingleSymbolViewController{
    func takeSymbol(){
//        发出前两个
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .take(2)
            .subscribe(onNext: { (content) in
                print(content)
            }).disposed(by: disposeBag)
    }
    func takeLast(){
//        发出后两个
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .takeLast(2)
            .subscribe(onNext: { (content) in
                print(content)
            }).disposed(by: disposeBag)
    }
    func takeUntil(){
//        一旦第二个序列发出元素就终止
        let startSignal = Observable<Int>.just(100).delay(.seconds(5), scheduler: MainScheduler.instance)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .takeUntil(startSignal)
            .subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
    func takeWhile(){
//        直到满足条件就暂停
        Observable.of(1, 2, 3).takeWhile{$0<2}.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----startWith-----
extension SingleSymbolViewController{
    func startWithSymbol()  {
//        在前面插入元素
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .startWith("1")
            .subscribe(onNext: { (content) in
                print(content)
            }).disposed(by: disposeBag)
    }
}
//MARK:-----skip-----
extension SingleSymbolViewController{
    func skipSymbol()  {
//        跳过头n个元素
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .skip(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    func skipUntilSymbol(){
//        直到startSignal发出元素后,才开始发出
        let startSignal = Observable<Int>.just(100).delay(.seconds(2), scheduler: MainScheduler.instance)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .skipUntil(startSignal)
            .subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
    func skipWhile(){
        Observable.of(1, 2, 3).skipWhile{$0<2}.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----Share-----
extension SingleSymbolViewController{
    func shareSymbol(){
//        不加share map会执行两次
//        加了share 就只会执行一次
        let observable = Observable.just("🤣").map{print($0)}.share(replay: 1, scope: .forever)
        observable.subscribe{print("Even:\($0)")}.disposed(by: disposeBag)
        observable.subscribe{print("Even:\($0)")}.disposed(by: disposeBag)
    }
}
//MARK:-----scan-----
extension SingleSymbolViewController{
//    对每一个元素应用一个函数,结果作为第一个元素发出,然后把结果填入到第二个元素的函数中去,以此类推  有点想reduce  但是reduce是只有一个结果 scan是每一步有一个结果
    func scanSymbol() {
        Observable.of(1, 2, 3).scan(1) { (initValue, next) -> Int in
            return initValue * next
        }.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----Retry-----
extension SingleSymbolViewController{
    func retrySymbol(){
        var count = 0
        let subject = Observable<String>.create { (observer) -> Disposable in
            observer.onNext("♥")
            if count == 0{
                observer.onError(LYError.init(des: "我错了"))
                count += 1
            }
            observer.onNext("♣")
            return Disposables.create()
        }
        subject.retry().subscribe(onNext: { (content) in
            print(content)
        },onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
//    当retryWhen里面的信号发出一次,就会执行一次retry的操作
    func retryWhenSymbol(){
        var count = 0
        let maxRetryCount = 4
        let subject = Observable<String>.create { (observer) -> Disposable in
            observer.onNext("♥")
            if count == 0{
                observer.onError(LYError.init(des: "我错了"))
                count += 1
            }
            observer.onNext("♣")
            return Disposables.create()
        }
        subject.retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
            return rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
                    guard index < maxRetryCount else {
                        return Observable.error(error)
                    }
                    return Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
                }
        }.subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----reduce-----
extension SingleSymbolViewController{
    func reduceSymbol(){
        Observable.of(1, 2, 3).reduce(1) { (initValue, next) -> Int in
            return initValue * next
        }.subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}

//MARK:-----map-----
extension SingleSymbolViewController{
    func mapSymbol()  {
        let subject = Observable.from([1,2,3,4,5,6])
        subject.map{$0*2}
            .subscribe(onNext: { (number) in
            print(number)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----groupBy-----
extension SingleSymbolViewController{
    func groupBySymbol(){
        let subject = Observable.from([1,2,3,4,5,6])
        subject.groupBy { (element) -> String in
            return element % 2 == 0 ? "偶数" : "奇数"
        }.subscribe { (event) in
            switch event{
                case let .next(group):
                    group.asObservable().subscribe({ (event) in
                        print("key：\(group.key) event：\(event)")
                    }).disposed(by: self.disposeBag)
                default:
                    print("")
            }
            
        }.disposed(by: disposeBag)
    }
}
//MARK:-----elementAt-----
extension SingleSymbolViewController{
    func elementAtSymbol()  {
//        只发出指定索引的元素
        let subject = Observable.from([1,2,3,4])
        subject.elementAt(2).subscribe(onNext: { (number) in
            print("elementAt====\(number)")
        }).disposed(by: disposeBag)
    }
}
//MARK:-----distinctUntilChanged-----
extension SingleSymbolViewController{
    func distinctUntilChangedSymbol() {
//        过滤相同的元素
        let subject = Observable.from([1,2,2,2,3,3,3,4])
        subject.distinctUntilChanged()
            .subscribe(onNext: { (number) in
                print("distinctUntilChanged====\(number)")
            }).disposed(by: disposeBag)
    }
}
//MARK:-----防抖-----
extension SingleSymbolViewController{
    func noShakeSymbol(){
//        debounce和throttle都有防抖
//        debounce在指定时间获取最后一个元素
//        throttle在指定时间段获取第一个和最后一个
//        throttle如有latest参数为false 则获取第一个
        let subject = Observable.from([1,2,3,4])
        subject.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (number) in
                print("debounce====\(number)")
            }).disposed(by: disposeBag)
        subject.throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (number) in
                print("throttle====\(number)")
            }).disposed(by: disposeBag)
        subject.throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (number) in
                print("throttle+latest====\(number)")
            }).disposed(by: disposeBag)
    }
}
//MARK:-----buffer-----
extension SingleSymbolViewController{
    func bufferSymbol(){
//        当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
        let subject1 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        subject1.buffer(timeSpan: .seconds(4), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (items) in
                print(items)
            } ).disposed(by: disposeBag)
    }
}
