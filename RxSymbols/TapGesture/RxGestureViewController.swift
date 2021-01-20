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
    var currentRoration:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initInterface()
        initDataSource()
    }
    //MARK:-----各种方法-----
    func bindData(){
        //MARK:-----tap-----
//        tapView.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { (tap) in
//                print(tap)
//        }).disposed(by: disposeBag)
        
//        tapView.rx.tapGesture { (gesture, _) in
//            gesture.numberOfTapsRequired = 2
//        }
//        .skip(1)
//        .subscribe(onNext: { (tap) in
//            print(tap)
//        }).disposed(by: disposeBag)
//
        //MARK:-----long-----
//        tapView.rx.longPressGesture()
//            .when(.began)
//            .subscribe(onNext: { (long) in
//                print(long)
//            }).disposed(by: disposeBag)
        
        //MARK:-----swipe滑动手势-----
//        tapView.rx.swipeGesture(.down,.left,.right,.up)
//            .when(.recognized)
//            .subscribe(onNext: { (swipe) in
//                print(swipe)
//            }).disposed(by: disposeBag)
        //MARK:-----pan拖动-----
//        let panEvent = tapView.rx.panGesture().share(replay: 1, scope: .forever)
//        panEvent.when(.began)
//            .do(onNext: {[weak self] (ges) in
//                ges.setTranslation(CGPoint.init(x: self?.tapView.transform.tx ?? 0, y: self?.tapView.transform.ty ?? 0), in: self?.tapView)
//            })
//            .asTranslation()
//            .subscribe(onNext: { [weak self](location) in
//                self?.label.text = String(format: "(%.2f, %.2f)", self!.tapView.frame.origin.x, self!.tapView.frame.origin.y)
//            }).disposed(by: disposeBag)
//
//        panEvent
//            .when(.possible, .changed)
//            .asTranslation()
//            .subscribe(onNext: { [weak self](location) in
//                self?.tapView.transform = CGAffineTransform(translationX: location.translation.x, y: location.translation.y)
//                self?.label.text = String(format: "(%.2f, %.2f)", self!.tapView.frame.origin.x, self!.tapView.frame.origin.y)
//            }).disposed(by: disposeBag)
//        panEvent.when(.ended)
//            .asTranslation()
//            .subscribe(onNext: { [weak self](location) in
//                self?.label.text = String(format: "(%.2f, %.2f)", self!.tapView.frame.origin.x, self!.tapView.frame.origin.y)
//            }).disposed(by: disposeBag)
        
        //MARK:-----rotation旋转-----
        let rotationEvent = tapView.rx.rotationGesture().share(replay: 1, scope: .whileConnected)
        rotationEvent
            .when(.possible, .began, .changed)
            .asRotation()
            .subscribe(onNext: {[weak self] rotation, _ in
                let tem = rotation + (self?.currentRoration ?? 0)
                self?.label.text = String(format: "%.2f rad", tem)
                self?.tapView.transform = CGAffineTransform(rotationAngle: tem)
            })
            .disposed(by: disposeBag)
        

        rotationEvent
            .when(.ended)
            .asRotation()
            .subscribe(onNext: {[weak self] rotation, _ in
                self?.currentRoration = rotation + (self?.currentRoration ?? 0)
                print("current\(rotation)")
            })
            .disposed(by: disposeBag)
    }
    //MARK:-----懒加载-----
    lazy var tapView: UIView = {
        let value = UIView(frame: CGRect(x: self.view.bounds.width/2 - 100, y: self.view.bounds.height/2 - 100, width: 200, height: 200))
        value.backgroundColor = .red
        return value
    }()
    lazy var label: UILabel = {
        let value = UILabel()
        value.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        value.text = ""
        value.textAlignment = .center
        value.font = .systemFont(ofSize: 12)
        return value
    }()
}
extension RxGestureViewController{
    //MARK:-----界面-----
    func initInterface() {
        view.addSubview(tapView)
        tapView.addSubview(label)
    }
    func initDataSource(){
        bindData()
    }
}

