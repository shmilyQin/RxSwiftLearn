//
//  RxWebViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/23.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
class RxWebViewController: BaseViewController {
    var dataSource:BehaviorRelay<[SectionModel<String,(title:String,VCName:String)>]> = BehaviorRelay(value: [])
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
        dataSource.asDriver().drive(myTableView.rx.items(dataSource: items)).disposed(by: disposeBag)
        myTableView.rx.modelSelected((title:String,VCName:String).self).subscribe(onNext: { [weak self](info) in
            guard let preName =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String , let currentVC = NSClassFromString(preName+"."+info.VCName) as? BaseViewController.Type else{
                fatalError("转换控制器失败")
            }
            let vc = currentVC.init()
            vc.title = info.title
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        let array = [(title:"常规监听",VCName:"OtherObservingViewController"),
                     (title:"调用JS的方法",VCName:"InvokeJSFunctionViewController"),
                     (title:"响应JS的方法",VCName:"ObservingJSFunctionViewController")]
        dataSource.accept([SectionModel<String, (title:String,VCName:String)>.init(model: "", items: array)])
        
    }
    //MARK:-----懒加载-----
    lazy var myTableView: UITableView = {
        let value = UITableView(frame: self.view.bounds, style: .plain)
        value.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return value
    }()
}
extension RxWebViewController{
    //MARK:-----界面-----
    func initInterface() {
        view.addSubview(myTableView)
    }
    func initDataSource(){
        bindData()
    }
}

