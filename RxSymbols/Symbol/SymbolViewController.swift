//
//  SymbolViewController.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/22.
//

import UIKit
import RxCocoa
import RxSwift
struct LYError: Error {
    var des=""
}
class SymbolViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "多序列"
//        zipSymbol()
//        withLatestFromSymbol()
//        withLatestFromSymbol2()
//        mergeSymbol()
//        combineLatestSymbol()
//        concatSymbol()
//        concatMapSymbol()
        
    }
}
//MARK:-----zip-----
extension SymbolViewController{
    func zipSymbol(){
//        一对一匹配后发出
        let subject1 = Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        let subject2 = Observable.of("A","B","C")
        let subject3 = Observable.of("1","2")
        Observable.zip(subject1,subject2,subject3).subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----withLatestFrom-----
extension SymbolViewController{
    func withLatestFromSymbol(){
//        当第一个 Observable 发出一个元素时，就立即取出第二个 Observable 中最新的元素，然后把第二个 Observable 中最新的元素发送出去。
        let subject1 = Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        let subject2 = Observable.of("A","B","C")
        subject1.withLatestFrom(subject2).subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
    }
    func withLatestFromSymbol2(){
//        当第一个 Observable 发出一个元素时，就立即取出第二个 Observable 中最新的元素，然后组合后发出。
        let subject1 = Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        let subject2 = Observable.of("A","B","C")
        subject1.withLatestFrom(subject2){(first,second) in
            return first + second
        }.subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----merge-----
extension SymbolViewController{
    func mergeSymbol(){
//        将多个 Observables 合并成一个，当某一个 Observable 发出一个元素时，他就将这个元素发出。
//        如果，某一个 Observable 发出一个 onError 事件，那么被合并的 Observable 也会将它发出，并且立即终止序列。
        let subject1 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map{"第一个的第\($0)次"}
        let subject2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map{"第二个的第\($0)次"}
        Observable.merge(subject1,subject2).subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
    }
}
//MARK:-----combineLatest-----
extension SymbolViewController{
    func combineLatestSymbol()  {
        let subject1 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let subject2 = Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance).map{"第二个的第\($0)次"}
        Observable.combineLatest(subject1,subject2).subscribe(onNext: { (info) in
            print(info)
        }).disposed(by: disposeBag)
    }
    
}
//MARK:-----Concat-----
extension SymbolViewController{
    func concatSymbol(){
//        多个序列组合在一起 当前面的序列发出完成事件后才开始订阅下一个序列
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        subject1.concat(subject2).subscribe(onNext: { (content) in
            print(content)
        }).disposed(by: disposeBag)
        subject1.onNext("这是苹果")
        // 表示subject1执行完成
        subject1.onCompleted()
        // 开始订阅subject2
        subject2.onNext("这是苹果2")
    }
    func concatMapSymbol(){
//        concatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。然后让这些 Observables 按顺序的发出元素，当前一个 Observable 元素发送完毕后，后一个 Observable 才可以开始发出元素。等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
        let subject1 = getFirst()
        let subject2 = getSecond()
        Observable.from([1,2]).concatMap { (number) -> Observable<String> in
            if number == 1{
                return subject1
            }
            return subject2
        }.subscribe(onNext: { (content) in
            print(content)
        })
        .disposed(by: disposeBag)
    }
    func getFirst() -> Observable<String> {
        return Observable.just("这是第一个").delay(.seconds(5), scheduler: MainScheduler.instance)
    }
    func getSecond() -> Observable<String> {
        return Observable.just("这是第二个").delay(.seconds(2), scheduler: MainScheduler.instance)
    }
}
