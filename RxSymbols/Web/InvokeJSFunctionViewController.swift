//
//  InvokeJSFunctionViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/23.
//

import UIKit
import WebKit
import RxWebKit
fileprivate let html = """
<!DOCTYPE html>
<html>
<head>
<title>Invoke Javascript function</title>
</head>
<body>
<h1>点击右上角按钮,传入参数,原生接受返回值,注意查看控制台</h1>

<script>
function showPrint(name) {
    return `${name}被点击了`
}
</script>

</body>
</html>

"""
class InvokeJSFunctionViewController : BaseViewController {
    let webview = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "点击调用", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self](_) in
            guard let self = self else { return }
            self.webview.rx.evaluateJavaScript("showPrint('我好帅')").observeOn(MainScheduler.instance).subscribe(onNext: { (event) in
                if let message = event as? String {
                    print(message)
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        webview.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
    }
}
