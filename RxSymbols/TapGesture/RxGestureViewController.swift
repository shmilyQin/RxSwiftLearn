//
//  RxGestureViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/25.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
class RxGestureViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initInterface()
        initDataSource()
    }
    //MARK:-----各种方法-----
    func bindData(){
        tapView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { (tap) in
                print(tap)
        }).disposed(by: disposeBag)
    }
    //MARK:-----懒加载-----
    lazy var tapView: UIView = {
        let value = UIView(frame: CGRect(x: self.view.bounds.width/2 - 50, y: 100, width: 100, height: 100))
        value.backgroundColor = .red
        return value
    }()
}
extension RxGestureViewController{
    //MARK:-----界面-----
    func initInterface() {
        view.addSubview(tapView)
    }
    func initDataSource(){
        bindData()
    }
}

