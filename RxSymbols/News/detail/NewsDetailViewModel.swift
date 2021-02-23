//
//  NewsDetailViewModel.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import Foundation
import RxSwift
import RxCocoa
class NewsDetailViewModel:LYBaseViewModel {
    struct Input {
        var startSingle:Observable<String>
        var refreshSingle:Observable<Void>
    }
    struct Output{
        var datasources:Driver<[NewsDetailModel]>
    }
    var disposeBag = DisposeBag()
    func transform(input: Input) -> Output {
        let combineSingle = Observable.combineLatest(input.startSingle,input.refreshSingle.startWith(())).debounce(.milliseconds(100), scheduler: MainScheduler.instance)
        let output = combineSingle.flatMapLatest {[weak self] (info) -> Single<[NewsDetailModel]> in
            guard let strongSelf = self else { return Single.just([])}
            return strongSelf.getNewsDetail(type: info.0)
        }.asDriver(onErrorJustReturn: [])
        return Output(datasources: output)
    }
    func getNewsDetail(type:String) -> Single<[NewsDetailModel]>{
        return lyApiProvider.rx.LYRequest(.news_detail(type: type))
            .mapArrayModel(NewsDetailModel.self, designatedPath: "result.data")
    }
}
