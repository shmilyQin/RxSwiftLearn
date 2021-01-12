//
//  BaseViewController.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/21.
//

import UIKit
@_exported import RxCocoa
@_exported import RxSwift
class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    deinit {
        print("deinit-------\(type(of: self))------")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
}
