//
//  loginFile.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/30.
//

import Foundation
import RxSwift
import RxCocoa
class LoginViewModel: LYBaseViewModel {
  struct Input {
    var phoneInput: Observable<String>
    var pswInput: Observable<String>
    var tapInut: Observable<Void>
  }
  
  struct Output {
    var nameValidation: Observable<ValidationResult>
    var pswValidation: Observable<ValidationResult>
    var loginResult: Observable<String>
    var loginEnable: Observable<Bool>
    var isStartAnimation: Observable<Bool>
  }
  
  func transform(input: Input) -> Output {
    let userSignal = input.phoneInput
    let pswSignal =  input.pswInput
    
    let userValidate = userSignal.map { content in
      return self.getValidationResult(content: content)
    }
    let pswValidate = pswSignal.map { psw in
      return self.getPswValidationResult(psw: psw)
    }
    
    let combineSignal = Observable.combineLatest(userValidate, pswValidate)
    let combineNameAndPsw = Observable.combineLatest(userSignal, pswSignal)
    let loginEnable =  combineSignal.map{$0.0.isSuccess && $0.1.isSuccess}
    
    let loginResult = input.tapInut.withLatestFrom(combineNameAndPsw).flatMapLatest { (phone,psw) in
      return self.loginRequest(phone: phone, code: psw)
    }
    let isStart = Observable.merge(input.tapInut.map{true},loginResult.map{_ in false})
    return Output(nameValidation: userValidate, pswValidation: pswValidate, loginResult: loginResult, loginEnable: loginEnable,isStartAnimation: isStart)
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
  func loginRequest(phone:String, code:String) -> Single<String>{
    return Single.just("\(phone)---\(code)").delay(.seconds(2), scheduler: MainScheduler.instance)
  }
}
//func bindViewModel(){
//  viewModel = LoginViewModel()
//  let input = LoginViewModel.Input(phoneInput: userNameField.rx.text.orEmpty.asObservable(), pswInput: pswTextField.rx.text.orEmpty.asObservable(), tapInut: loginBtn.rx.whsTap().mapToVoid())
//  let out = viewModel.transform(input: input)
//  out.nameValidation.bind(to: tipLabel.rx.tipResult).disposed(by: disposeBag)
//  out.pswValidation.bind(to: pswTipLabel.rx.tipResult).disposed(by: disposeBag)
//  out.loginEnable.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
//  out.loginResult.subscribe(onNext: { content in
//    print(content)
//  }).disposed(by: disposeBag)
//}
