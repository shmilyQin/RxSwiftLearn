//
//  TraitsViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/30.
//

import UIKit
class TraitsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        singleTrait().subscribe(onSuccess: <#T##((String) -> Void)?##((String) -> Void)?##(String) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
//        completableTrait().subscribe(onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
    }

}
extension TraitsViewController{
    func singleTrait()->Single<String>{
//        single简单来说就是只会发出一个元素或者产生error事件,不会状态共享 常用于HTTP请求
        return Single.create { (single) -> Disposable in
            single(.success("123"))
//            single(.error(<#T##Error#>))
            return Disposables.create()
        }
    }
    func completableTrait() ->Completable{
//        completable简单来说就是只会产生complete事件或者产生error事件,不会状态共享
        return Completable.create { (completable) -> Disposable in
            completable(.completed)
//            completable(.error(T##Error))
            return Disposables.create()
        }
    }
    func maybe() -> Maybe<String>{
//    maybe简单来说就是要么产生元素 要么产生compldeted 要么error
        return Maybe.create { (ob) -> Disposable in
            ob(.success("1111"))
            return Disposables.create()
        }
    }
}
extension TraitsViewController{
//    Driver
}

