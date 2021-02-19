//
//  NewsListViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/2/19.
//

import UIKit
import RxDataSources
typealias ListModel = (type: String, name: String)
class NewsListViewController: BaseViewController {
    var dataSource:BehaviorRelay<[NewsSection]> = BehaviorRelay(value:[])
    var viewModel = ListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mytableView)
        bindData()
    }
   
    func bindData(){
        let items = RxTableViewSectionedReloadDataSource<NewsSection>(configureCell: {(ds,tv,ip,element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
            cell.textLabel?.text = element.name
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        dataSource.asDriver().drive(mytableView.rx.items(dataSource: items)).disposed(by: disposeBag)
        let array = [(type:"shehui",name:"社会"),(type:"guonei",name:"国内"),(type:"guoji",name:"国际"),(type:"yule",name:"娱乐"),(type:"tiyu",name:"体育"),(type:"junshi",name:"军事"),(type:"keji",name:"科技")]
        dataSource.accept([NewsSection.init(header: "", items: array)])
        mytableView.rx.modelSelected(ListModel.self).subscribe(onNext: { [weak self](model) in
            let vc = NewsDetailViewController()
            vc.type = model.type
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    lazy var mytableView: UITableView = {
        let value = UITableView.init(frame: CGRect(x: 0, y: 64, width: 375, height: UIScreen.main.bounds.height - 64), style: .plain)
        value.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return value
    }()
}
struct NewsSection {
    var header:String = ""
    var items:[Item] = []
}
extension NewsSection: SectionModelType{
    typealias Item = ListModel
    init(original: NewsSection, items: [ListModel]) {
        self = original
        self.items = items
    }
}
