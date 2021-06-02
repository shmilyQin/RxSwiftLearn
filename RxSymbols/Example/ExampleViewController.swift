//
//  ExampleViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/2.
//

import UIKit
import RxSwift
import RxCocoa
class ExampleViewController: BaseViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      let textField = UITextField(frame: CGRect(x: 0, y: 100, width: 100, height: 40))
      view.addSubview(textField)
      textField.placeholder = "请输入"
      let countLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 40))
      view.addSubview(countLabel)
      textField.rx.text.orEmpty
        .map { content in
        return content.count > 5 ? CheckResult.success : CheckResult.error
      }
        .bind(to: countLabel.rx.result)
        .disposed(by: disposeBag)
    }
    
}
extension Reactive where Base: UILabel{
  var result: Binder<CheckResult>{
    return Binder(base){(label,result) in
      label.text = result.description
      label.textColor = result.messageColor
    }
  }
}
enum  CheckResult{
  case success
  case error
}
extension CheckResult: CustomStringConvertible {
  var description: String {
    switch self {
    case .success:
      return "用户名可用"
    case .error:
      return "用户名不可用"
    }
  }
  var messageColor:UIColor {
    switch self {
    case .success:
      return .green
    case .error:
      return .red
    }
  }
}
