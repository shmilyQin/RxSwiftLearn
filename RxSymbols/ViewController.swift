//
//  ViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/23.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
class ViewController: UIViewController {
    var dataSource:BehaviorRelay<[SectionModel<String,(title:String,VCName:String)>]> = BehaviorRelay(value: [])
    var dispose = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        initInterface()
        initDataSource()
    }
    //MARK:-----各种方法-----
    func bindData(){
        let items = RxTableViewSectionedReloadDataSource<SectionModel<String,(title:String,VCName:String)>>.init { (data, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = element.title
            return cell
        }
        dataSource.asDriver().drive(myTableView.rx.items(dataSource: items)).disposed(by: dispose)
        myTableView.rx.modelSelected((title:String,VCName:String).self).subscribe(onNext: { [weak self](info) in
            guard let preName =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String , let currentVC = NSClassFromString(preName+"."+info.VCName) as? BaseViewController.Type else{
                fatalError("转换控制器失败")
            }
            let vc = currentVC.init()
            vc.title = info.title
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: dispose)
        
        let array = [(title:"序列",VCName:"ObservableViewController"),(title:"特征序列",VCName:"TraitsViewController"),
                     (title:"可监听序列&观察者",VCName:"ObservableAndObserverViewController"),(title:"针对单序列的操作符",VCName:"SingleSymbolViewController"),
                     (title:"针对多序列的操作符",VCName:"SymbolViewController"),(title:"flatMap",VCName:"FlatMapLatestViewController"),
                     (title:"刷新",VCName:"RefreshViewController"),(title:"Rx手势",VCName:"RxGestureViewController")]
        dataSource.accept([SectionModel<String, (title:String,VCName:String)>.init(model: "", items: array)])
        
    }
    //MARK:-----懒加载-----
    lazy var myTableView: UITableView = {
        let value = UITableView(frame: self.view.bounds, style: .plain)
        value.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return value
    }()
}
extension ViewController{
    //MARK:-----界面-----
    func initInterface() {
        view.addSubview(myTableView)

    }
    func initDataSource(){
        bindData()
    }
}

