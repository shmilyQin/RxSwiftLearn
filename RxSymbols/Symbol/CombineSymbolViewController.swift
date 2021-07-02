//
//  CombineSymbolViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/24.
//

import UIKit
import RxSwift
import RxRelay
class CombineSymbolViewController: BaseViewController {
  var nameSignalB: PublishRelay<String> = PublishRelay()
  var contentSignalB: PublishRelay<String> = PublishRelay()
  var nameCount = 0
  var contentCount = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(nameBtn)
    view.addSubview(contentBtn)
    bindData()
    // Do any additional setup after loading the view.
  }
  func bindData(){
    nameBtn.rx.tap.subscribe {[weak self] _ in
      let count = self?.nameCount ?? 0
      self?.nameCount = count + 1
      self?.nameSignalB.accept("A:\(self?.nameCount ?? 0)")
    }.disposed(by: disposeBag)
    contentBtn.rx.tap.subscribe {[weak self] _ in
      let count = self?.contentCount ?? 0
      self?.contentCount = count + 1
      self?.contentSignalB.accept("B:\(self?.contentCount ?? 0)")
    }.disposed(by: disposeBag)
    
    let nameSignal = nameSignalB.asObservable().share(replay: 1, scope: .forever)
    let contentSignal = contentSignalB.asObservable().share(replay: 1, scope: .forever)
    
    Observable.combineLatest(nameSignal,contentSignal).subscribe(onNext: { info in
      print("combineLatest=====>\(info.0)===\(info.1)")
    }).disposed(by: disposeBag)
    
    Observable.zip(nameSignal,contentSignal).subscribe(onNext: { info in
      print("zip=====>\(info.0)===\(info.1)")
    }).disposed(by: disposeBag)
    
    Observable.merge(nameSignal,contentSignal).subscribe(onNext: { content in
      print("merge=====>\(content)")
    }).disposed(by: disposeBag)
    
  }
  lazy var nameBtn: UIButton = {
    let value = UIButton(frame: CGRect(x: self.view.center.x - 150, y: 100, width: 100, height: 40))
    value.backgroundColor = .red
    value.setTitle("A", for: .normal)
    value.setTitleColor(.white, for: .normal)
    return value
  }()
  lazy var contentBtn: UIButton = {
    let value = UIButton(frame: CGRect(x: self.view.center.x + 50, y: 100, width: 100, height: 40))
    value.backgroundColor = .green
    value.setTitle("B", for: .normal)
    value.setTitleColor(.white, for: .normal)
    return value
  }()
}
