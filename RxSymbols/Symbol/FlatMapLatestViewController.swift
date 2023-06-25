//
//  FlatMapLatestViewController.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/17.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
class FlatMapLatestViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "组合"
//        flatMapAndFlatMapLatest()
        //    flatMapAndConcat()
        Task{
            do {
               let result = try await flatMapAndConcatWithAsync()
                print("result --- \(result)")
            } catch let error {
                print("error -- \(error)")
            }
        }
    }
    
    func flatMapAndFlatMapLatest(){
        let textF = UITextField(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        textF.placeholder = "请输入"
        view.addSubview(textF)
        textF.rx.text.orEmpty.flatMap {[weak self] (text) -> Observable<String> in
            guard let strongSelf = self else { return Observable.empty()}
            return strongSelf.getSecond(content: text)
        }.subscribe(onNext: { (content) in
            print("flatMap\(content)")
        }).disposed(by: disposeBag)
        
        textF.rx.text.orEmpty.flatMapLatest { [weak self] (text) -> Observable<String> in
            guard let strongSelf = self else { return Observable.empty()}
            return strongSelf.getSecond(content: text)
        }.subscribe(onNext: { (content) in
            print("flatMapLatest\(content)")
        }).disposed(by: disposeBag)
    }
    
    func flatMapAndConcat(){
        let netA = getFirst(content: "netA")
        let netB = getSecond(content: "netB")
        let netC = getThird(content: "netC")
        Observable.zip(netA, netB).map{$0+$1}.concat(netC).subscribe(onNext: { info in
            print("zip===\(info)")
        }).disposed(by: disposeBag)
        
        Observable.zip(netA, netB).flatMap { info in
            return self.getThird(content: info.0+info.1)
        }.subscribe(onNext: { content in
            print("flatmap===\(content)")
        }).disposed(by: disposeBag)
    }
    
    func flatMapAndConcatWithAsync() async throws -> [String]{
        async let netA = getFirst(content: "netA").asSingle().value
        async let netB = getSecond(content: "netB").asSingle().value
        
        let resultAB = try await [netA, netB]
        
        let netC = try await getThird(content: "netC").asSingle().value

        return resultAB + [netC]
        
    }
    
    
}
extension FlatMapLatestViewController{
    func getFirst(content:String) -> Observable<String> {
        return Observable.just("这是第一个\(content)").delay(.seconds(5), scheduler: MainScheduler.instance)
    }
    func getSecond(content:String) -> Observable<String> {
        return Observable.just("这是第二个\(content)").delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    func getThird(content:String) -> Observable<String> {
        return Observable.just("这是第三个\(content)").delay(.seconds(2), scheduler: MainScheduler.instance)
    }
}
