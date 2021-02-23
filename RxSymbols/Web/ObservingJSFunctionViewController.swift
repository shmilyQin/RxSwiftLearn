//
//  ObservingJSFunctionViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/23.
//

import UIKit
import WebKit
import RxWebKit

fileprivate let html = """
<!DOCTYPE html>
<meta content="width=device-width,user-scalable=no" name="viewport">

<html>
<body>

<p>点击下方按钮,事件的响应传给原生,留意控制台输出</p>

<button onclick="sendScriptMessage()">点我</button>

<p id="demo"></p>

<script>
function sendScriptMessage() {
    window.webkit.messageHandlers.RxWebKitScriptMessageHandler.postMessage('帅哥被点了一下')
}
</script>

</body>
</html>
"""

class ObservingJSFunctionViewController : BaseViewController {
    let webview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.configuration.userContentController.rx.scriptMessage(forName: "RxWebKitScriptMessageHandler").asObservable().subscribe(onNext: {[weak self] (message) in
            guard let message = message.body as? String , let self = self else { return }
            let alertVC = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
            alertVC.addAction(sureAction)
            self.present(alertVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height)
    }
}
