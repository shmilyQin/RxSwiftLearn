//
//  LoginViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/28.
//

import UIKit
import RxSwift
import RxCocoa
/**
 校验手机号是否大于11位,如果不满足就有文字提示,且为红色字体,通过则为绿色字体
 密码是否大于6位,如果不满足就有文字提示,且为红色字体,通过则为绿色字体
 如果上述条件都满足,则登录按钮的Enable为true
 点击登录按钮后,开启indicatorView的动画,登录成功后取消indicator的动画
 */
class LoginViewController: BaseViewController {
  var viewModel: LoginViewModel!
  override func viewDidLoad() {
    super.viewDidLoad()
        view.addSubview(userNameField)
        view.addSubview(tipLabel)
        view.addSubview(pswTextField)
        view.addSubview(pswTipLabel)
        view.addSubview(loginBtn)
        view.addSubview(activityIndicator)
//    view.addSubview(loginView)
    bindData()
    bindViewModel()
  }
  func bindViewModel(){
    viewModel = LoginViewModel()
    let input = LoginViewModel.Input(phoneInput: userNameField.rx.text.orEmpty.asObservable(), pswInput: pswTextField.rx.text.orEmpty.asObservable(), tapInut: loginBtn.rx.whsTap().mapToVoid())
    
    let out = viewModel.transform(input: input)
    
    out.nameValidation.bind(to: tipLabel.rx.tipResult).disposed(by: disposeBag)
    out.pswValidation.bind(to: pswTipLabel.rx.tipResult).disposed(by: disposeBag)
    out.loginEnable.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    
    out.loginResult.subscribe(onNext: { content in
      print(content)
    }).disposed(by: disposeBag)
  }
  func bindData(){
    
    let userSignal = userNameField.rx.text.orEmpty.asObservable().map { content -> String in
      print("执行手机号")
      return content
    }
    let pswSignal =  pswTextField.rx.text.orEmpty.asObservable().map { content -> String in
      print("执行密码")
      return content
    }
    
    let userValidate = userSignal.map { content in
      return self.getValidationResult(content: content)
    }
    let pswValidate = pswSignal.map { psw in
      return self.getPswValidationResult(psw: psw)
    }
    userValidate.bind(to: tipLabel.rx.tipResult).disposed(by: disposeBag)
    pswValidate.bind(to: pswTipLabel.rx.tipResult).disposed(by: disposeBag)

    let combineSignal = Observable.combineLatest(userValidate, pswValidate)
    let combineNameAndPsw = Observable.combineLatest(userSignal, pswSignal)

    combineSignal.map{$0.0.isSuccess && $0.1.isSuccess}.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    let loginResult = loginBtn.rx.whsTap().withLatestFrom(combineNameAndPsw)
      .flatMapLatest {[weak self](phone,psw) -> Observable<String> in
      guard let strongSelf = self else{return Observable.empty()}
      return strongSelf.loginRequest(phone: phone, code: psw)
    }
    let isStart = Observable.merge(loginBtn.rx.tap.map{_ in true},loginResult.map{_ in false})
    isStart.bind(to: activityIndicator.rx.isAnimating).disposed(by: disposeBag)
    
    loginResult.subscribe(onNext: {[weak self] result in
      self?.showLoginAlert(content: result)
    }).disposed(by: disposeBag)
  }
  func showLoginAlert(content:String){
    let alert = UIAlertController.init(title: nil, message: content, preferredStyle: .alert)
    let sure = UIAlertAction.init(title: "确定", style: .default, handler: nil)
    alert.addAction(sure)
    self.present(alert, animated: true, completion: nil)
  }
  func getValidationResult(content:String) -> ValidationResult{
    if content.count > 10 {
      return .success(message: "该账号可用")
    }
    return .failed(message: "该账号不可用")
  }
  func getPswValidationResult(psw:String) -> ValidationResult{
    if psw.count > 5 {
      return .success(message: "该密码可用")
    }
    return .failed(message: "该密码不可用")
  }
  func loginRequest(phone:String, code:String) -> Observable<String>{
    return Observable.just("\(phone)---\(code)").delay(.seconds(2), scheduler: MainScheduler.instance)
  }
  
  lazy var userNameField: UITextField = {
    let value = UITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 100, width: 150, height: 40))
    value.borderStyle = .roundedRect
    value.font = UIFont.systemFont(ofSize: 14)
    value.placeholder = "输入用户名"
    return value
  }()
  lazy var tipLabel: UILabel = {
    let value = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 145, width: 150, height: 30))
    value.textColor = .red
    value.font = UIFont.systemFont(ofSize: 12)
    return value
  }()
  lazy var pswTextField: UITextField = {
    let value = UITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 195, width: 150, height: 40))
    value.borderStyle = .roundedRect
    value.font = UIFont.systemFont(ofSize: 14)
    value.placeholder = "密码"
    return value
  }()
  lazy var pswTipLabel: UILabel = {
    let value = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 75, y: 240, width: 150, height: 30))
    value.textColor = .red
    value.font = UIFont.systemFont(ofSize: 12)
    return value
  }()
  lazy var loginBtn: UIButton = {
    let value = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2.0  - 50, y: 300, width: 100, height: 40))
    value.setTitle("登录", for: .normal)
    value.setTitle("登录", for: .disabled)
    value.setTitleColor(.white, for: [.normal , .disabled])
    value.setBackgroundImage(UIImage.from(color: .green), for: .normal)
    value.setBackgroundImage(UIImage.from(color: .lightGray), for: .disabled)
    return value
  }()
  lazy var activityIndicator: UIActivityIndicatorView = {
    let value = UIActivityIndicatorView(style: .large)
    value.frame = CGRect.init(x:0 , y: 0, width: 60, height: 60)
    value.center = self.view.center
    value.backgroundColor = .gray
    return value
  }()
  lazy var loginView: LoginView = {
    let value = LoginView(frame: self.view.bounds)
    return value
  }()
}
enum ValidationResult {
  case success(message:String)
  case failed(message:String)
}
extension ValidationResult: CustomStringConvertible{
  var description: String {
    switch self {
    case let .success(message):
      return message
    case let .failed(message):
      return message
    }
  }
  var textColor:UIColor{
    switch self {
    case .success:
      return .green
    case .failed:
      return .red
    }
  }
  var isSuccess:Bool{
    switch self {
    case .success:
      return true
    case .failed:
      return false
    }
  }
}
extension Reactive where Base:UILabel{
  var tipResult:Binder<ValidationResult>{
    return Binder(base) { label, flg in
      label.textColor = flg.textColor
      label.text = flg.description
    }
  }
}
extension Reactive where Base: UIButton{
  func whsTap(timeInterval:RxTimeInterval = .milliseconds(500)) -> Observable<Void>{
    return tap.asObservable().throttle(timeInterval, latest: false, scheduler: MainScheduler.instance).mapToVoid()
  }
}
extension UIImage {
  class func from(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
  }
}
