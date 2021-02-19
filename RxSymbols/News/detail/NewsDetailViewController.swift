//
//  NewsDetailViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import UIKit
import RxSwift
import RxDataSources
import RxRelay
class NewsDetailViewController: BaseViewController {
    var type = ""
    var viewModel = NewsDetailViewModel()
    var dataSource:BehaviorRelay<[DetailSection]> = BehaviorRelay(value:[])
    var rightItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        initInterface()
        initDataSource()
    }
    func addRightItem(){
        rightItem.title = "刷新"
        rightItem.style = .plain
        navigationItem.rightBarButtonItem = rightItem
    }
    func bindData(){
        let items = RxTableViewSectionedReloadDataSource<DetailSection>(configureCell: {(ds,tv,ip,element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
            cell.textLabel?.text = element.title
            return cell
        })
        dataSource.asDriver().drive(mytableView.rx.items(dataSource: items)).disposed(by: disposeBag)
        
        let input = NewsDetailViewModel.Input(startSingle: Observable.just(type), refreshSingle: rightItem.rx.tap.mapToVoid())
        let outPut = viewModel.transform(input: input)
        outPut.datasources.drive(onNext: {[weak self] (result) in
            self?.dataSource.accept([DetailSection.init(header: "", items: result)])
        }).disposed(by: disposeBag)
    }
    //MARK:-----各种方法-----
    //MARK:-----懒加载-----
    lazy var mytableView: UITableView = {
        let value = UITableView.init(frame: CGRect(x: 0, y: 64, width: 375, height: UIScreen.main.bounds.height - 64), style: .plain)
        value.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return value
    }()
}
extension NewsDetailViewController{
    //MARK:-----界面-----
    func initInterface() {
        view.addSubview(mytableView)
        addRightItem()
    }
    func initDataSource(){
        bindData()
    }
}
struct DetailSection {
    var header = ""
    var items:[Item] = []
}
extension DetailSection:SectionModelType{
    typealias Item = NewsDetailModel
    init(original: DetailSection, items: [NewsDetailModel]) {
        self = original
        self.items = items
    }
}
