//
//  LoginView.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/7/1.
//

import UIKit
import RxSwift
import RxCocoa
class LoginView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(userNameField)
    addSubview(tipLabel)
    addSubview(pswTextField)
    addSubview(pswTipLabel)
    addSubview(loginBtn)
    addSubview(activityIndicator)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  fileprivate lazy var userNameField: UITextField = {
    let value = UITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 100, width: 150, height: 40))
    value.borderStyle = .roundedRect
    value.font = UIFont.systemFont(ofSize: 14)
    value.placeholder = "输入用户名"
    return value
  }()
  fileprivate lazy var tipLabel: UILabel = {
    let value = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 145, width: 150, height: 30))
    value.textColor = .red
    value.font = UIFont.systemFont(ofSize: 12)
    return value
  }()
  fileprivate lazy var pswTextField: UITextField = {
    let value = UITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 195, width: 150, height: 40))
    value.borderStyle = .roundedRect
    value.font = UIFont.systemFont(ofSize: 14)
    value.placeholder = "密码"
    return value
  }()
  fileprivate lazy var pswTipLabel: UILabel = {
    let value = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 240, width: 150, height: 30))
    value.textColor = .red
    value.font = UIFont.systemFont(ofSize: 12)
    return value
  }()
  fileprivate lazy var loginBtn: UIButton = {
    let value = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 50, y: 300, width: 100, height: 40))
    value.setTitle("登录", for: .normal)
    value.setTitle("登录", for: .disabled)
    value.setTitleColor(.white, for: [.normal , .disabled])
    value.setBackgroundImage(UIImage.from(color: .green), for: .normal)
    value.setBackgroundImage(UIImage.from(color: .lightGray), for: .disabled)
    return value
  }()
  fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
    let value = UIActivityIndicatorView(style: .large)
    value.frame = CGRect.init(x:0 , y: 0, width: 60, height: 60)
    value.center = self.center
    value.backgroundColor = .gray
    return value
  }()
}
extension Reactive where Base: LoginView{
  var loginAction: ControlEvent<Void>{
    let source = base.loginBtn.rx.whsTap().asObservable()
    return ControlEvent(events: source)
  }
  var nameInputAction: ControlEvent<String>{
    let source = base.userNameField.rx.text.orEmpty.asObservable()
    return ControlEvent(events: source)
  }
  var pswInputAction: ControlEvent<String>{
    let source = base.pswTextField.rx.text.orEmpty.asObservable()
    return ControlEvent(events: source)
  }
  var isLoginEnable: Binder<Bool>{
    return Binder(base) {view,flag in
      view.loginBtn.isEnabled = flag
    }
  }
  var nameValidate: Binder<ValidationResult>{
    return Binder(base) {view,content in
      view.tipLabel.text = content.description
      view.tipLabel.textColor = content.textColor
    }
  }
  var pswValidate: Binder<ValidationResult>{
    return Binder(base) {view,content in
      view.pswTipLabel.text = content.description
      view.pswTipLabel.textColor = content.textColor
    }
  }
  var isAnimation: Binder<Bool>{
    return Binder(base) {view,flag in
      if flag {
        view.activityIndicator.startAnimating()
      }else{
        view.activityIndicator.stopAnimating()
      }
    }
  }
}
//func bindLoginViewData(){
//  let input = LoginViewModel.Input(phoneInput: loginView.rx.nameInputAction.asObservable(), pswInput: loginView.rx.pswInputAction.asObservable(), tapInut: loginView.rx.loginAction.asObservable())
//  let out = viewModel.transform(input: input)
//  out.nameValidation.bind(to: loginView.rx.nameValidate).disposed(by: disposeBag)
//  out.pswValidation.bind(to: loginView.rx.pswValidate).disposed(by: disposeBag)
//  out.loginEnable.bind(to: loginView.rx.isLoginEnable).disposed(by: disposeBag)
//  out.isStartAnimation.bind(to: loginView.rx.isAnimation).disposed(by: disposeBag)
//  out.loginResult.subscribe(onNext: { content in
//    print(content)
//  }).disposed(by: disposeBag)
//}
