//
//  FlatMapLatestViewController.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/17.
//

import UIKit
import RxCocoa
import RxSwift
class FlatMapLatestViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "flatMap"
        let textF = UITextField(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        textF.placeholder = "请输入"
        view.addSubview(textF)
        textF.rx.text.orEmpty.flatMap {[weak self] (text) -> Observable<String> in
            if text.count < 2{
                return self!.getFirst(content: text)
            }
            return self!.getSecond(content: text)
        }.subscribe(onNext: { (content) in
            print("flatMap\(content)")
        }).disposed(by: disposeBag)
        
        textF.rx.text.orEmpty.flatMapLatest { [weak self] (text) -> Observable<String> in
            if text.count < 2{
                return self!.getFirst(content: text)
            }
            return self!.getSecond(content: text)
        }.subscribe(onNext: { (content) in
            print("flatMapLatest\(content)")
        }).disposed(by: disposeBag)
    }
    func getFirst(content:String) -> Observable<String> {
        return Observable.just("这是第一个").delay(.seconds(5), scheduler: MainScheduler.instance)
    }
    func getSecond(content:String) -> Observable<String> {
        return Observable.just("这是第二个").delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
