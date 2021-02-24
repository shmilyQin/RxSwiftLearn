//
//  OtherObservingViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/23.
//

import UIKit
import WebKit
import RxWebKit
import Toast_Swift
class OtherObservingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        loadHtml()
        bindData()
        
    }
    func loadHtml()  {
        webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
    }
    func bindData()  {
        webView.rx.title
        webView.rx.didStartProvisionalNavigation.subscribe(onNext: {[weak self] (info) in
            self?.view.makeToast("加载中...")
        }).disposed(by: disposeBag)
        webView.rx.didFinishNavigation.subscribe(onNext: {[weak self] (info) in
            self?.view.makeToast("加载完成")
        }).disposed(by: disposeBag)
    }
    lazy var webView: WKWebView = {
        let value = WKWebView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
        return value
    }()
}
