//
//  ListViewModel.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/9.
//

import Foundation
import RxCocoa
import RxSwift
protocol LYBaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input:Input) -> Output
    
}
class ListViewModel: LYBaseViewModel{
    struct Input {
        let headerRefreshIng:Driver<Void>
        let footerRefreshIng:Driver<Void>
    }
    struct Output {
        var results:BehaviorRelay<[String]> = BehaviorRelay(value: [])
        var endRefreshing:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }
    let networkService = NetworkService()
    var disposeBag = DisposeBag()
    func transform(input: Input) -> Output {
        let out = Output()
        input.headerRefreshIng.startWith(()).flatMapLatest{[weak self] in
            (self?.networkService.getRandomResult())!
        }.drive(out.results).disposed(by: disposeBag)
        
        input.footerRefreshIng.flatMap{[weak self] in
            (self?.networkService.getRandomResult())!
        }.drive(onNext: { (result) in
            out.results.accept(out.results.value + result)
        }).disposed(by: disposeBag)
        
        out.results.map{ _ in true }.bind(to: out.endRefreshing).disposed(by: disposeBag)
        return out
    }
}
