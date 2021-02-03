//
//  RefreshViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2020/12/24.
//

import UIKit
import RxCocoa
import RxDataSources
class RefreshViewController: BaseViewController {
    var dataSource:BehaviorRelay<[MySection]> = BehaviorRelay(value:[])
    var viewModel = ListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "刷新"
        view.addSubview(mytableView)
        bindData()
    }
    func bindData(){
        let items = RxTableViewSectionedReloadDataSource<MySection>(configureCell: {(ds,tv,ip,element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
            cell.textLabel?.text = element
            return cell
        })
        dataSource.asDriver().drive(mytableView.rx.items(dataSource: items)).disposed(by: disposeBag)
        mytableView.es.addPullToRefresh()
        mytableView.es.addInfiniteScrolling()
        let input = ListViewModel.Input(headerRefreshIng: mytableView.header!.rx.refreshing.asDriver(), footerRefreshIng: mytableView.footer!.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)
        output.headerDriver.drive(onNext: { [weak self](array) in
            self?.dataSource.accept([MySection.init(header: "", items:array)])
        }).disposed(by: disposeBag)
        output.endDriver.drive(onNext: { [weak self](array) in
            self?.dataSource.accept([MySection.init(header: "", items: (self?.dataSource.value.first?.items ?? []) + array)])
        }).disposed(by: disposeBag)
        output.endRefreshing.asDriver().drive(mytableView.header!.rx.endRefreshing).disposed(by: disposeBag)
        output.endRefreshing.asDriver().drive(mytableView.footer!.rx.endRefreshing).disposed(by: disposeBag)
//        output.results.subscribe(onNext: { [weak self](array) in
//            self?.dataSource.accept([MySection.init(header: "", items:array)])
//        }).disposed(by: disposeBag)
//        output.endRefreshing.asDriver().drive(mytableView.header!.rx.endRefreshing).disposed(by: disposeBag)
//        output.endRefreshing.asDriver().drive(mytableView.footer!.rx.endRefreshing).disposed(by: disposeBag)
    }
    lazy var mytableView: UITableView = {
        let value = UITableView.init(frame: CGRect(x: 0, y: 64, width: 375, height: UIScreen.main.bounds.height - 64), style: .plain)
        value.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return value
    }()
}
struct MySection {
    var header:String = ""
    var items:[Item] = []
}
extension MySection: SectionModelType{
    typealias Item = String
    init(original: MySection, items: [String]) {
        self = original
        self.items = items
    }
}
