//
//  TraitsViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/30.
//

import UIKit
import RxSwift
import RxCocoa
class TraitsViewController: BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
extension TraitsViewController{
  func singleTrait()->Single<String>{
    //        single简单来说就是只会发出一个元素或者产生error事件,不会状态共享 常用于HTTP请求
    return Single.create { (single) -> Disposable in
      single(.error(LYError(des: "长得帅也是一种错")))
      single(.success("123"))
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
    //    maybe简单来说就是要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
    return Maybe.create { (ob) -> Disposable in
      ob(.success("1111"))
//      ob(.error(<#T##Error#>))
//      ob(.completed)
      return Disposables.create()
    }
  }
}
extension TraitsViewController{
  //    Driver
  func bindData(){
    let textField = UITextField(frame: CGRect(x: 0, y: 100, width: 100, height: 40))
    view.addSubview(textField)
    textField.placeholder = "请输入"
    let countLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 100, height: 40))
    view.addSubview(countLabel)
    
    let contentLabel = UILabel(frame: CGRect(x: 0, y: 250, width: 100, height: 40))
    view.addSubview(contentLabel)
    
    let result = textField.rx.text.orEmpty.throttle(.milliseconds(500), scheduler: MainScheduler.instance).flatMapLatest {[weak self] content in
      return self?.netWorking(content: content).asObservable().observeOn(MainScheduler.instance).catchErrorJustReturn("发生了错误,但是捕获了,继续请求") ?? Observable.empty()
    }.share(replay: 1, scope: .forever)
    result.map{"\($0.count)"}.bind(to: countLabel.rx.text).disposed(by: disposeBag)
    result.bind(to: contentLabel.rx.text).disposed(by: disposeBag)
    
//    let result = textField.rx.text.orEmpty.asDriver().throttle(.milliseconds(500)).flatMapLatest { [weak self]content in
//      return self?.netWorking(content: content).asDriver(onErrorJustReturn: "报错了") ?? Driver.empty()
//    }
//    result.map{"\($0.count)"}.drive(countLabel.rx.text).disposed(by: disposeBag)
//    result.drive(contentLabel.rx.text).disposed(by: disposeBag)
  }
  func netWorking(content:String) -> Single<String>{
    return Single<String>.create { single in
      if content == "quit"{
        single(.error(LYError(des: "发生错误")))
      }else{
        single(.success(content))
        print(content)
      }
      return Disposables.create()
    }
  }
}

