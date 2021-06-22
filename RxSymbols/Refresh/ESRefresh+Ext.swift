//
//  ESRefresh+Ext.swift
//  ReactorKitDemo
//
//  Created by 覃孙波 on 2020/12/9.
//

import Foundation
import RxSwift
import RxCocoa
import ESPullToRefresh
public extension ES where Base: UIScrollView {
    @discardableResult
    func addPullToRefresh() -> ESRefreshHeaderView {
        removeRefreshHeader()
        let header = ESRefreshHeaderView.init(frame: .zero, isAnimator: true)
        let headerH = header.animator.executeIncremental
        header.frame = CGRect.init(x: 0.0, y: -headerH /* - contentInset.top */, width: self.base.bounds.size.width, height: headerH)
        self.base.addSubview(header)
        self.base.header = header
        return header
    }
    @discardableResult
    func addInfiniteScrolling() -> ESRefreshFooterView {
        removeRefreshFooter()
        let footer = ESRefreshFooterView(frame: .zero, isAnimator: true)
        let footerH = footer.animator.executeIncremental
        footer.frame = CGRect.init(x: 0.0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.bounds.size.width, height: footerH)
        self.base.addSubview(footer)
        self.base.footer = footer
        return footer
    }
}
extension ESRefreshHeaderView{
    convenience init(frame: CGRect,isAnimator:Bool) {
        self.init(frame: frame)
        // 只是区分而已
        if !isAnimator{return}
        self.animator = ESRefreshHeaderAnimator.init()
    }
}
extension ESRefreshFooterView{
    convenience init(frame: CGRect,isAnimator:Bool) {
        self.init(frame: frame)
        //只是区分而已
        if !isAnimator{return}
        self.animator = ESRefreshFooterAnimator.init()
    }
}
extension Reactive where Base: ESRefreshComponent{
    var refreshing: ControlEvent<Void>{
        let source:Observable<Void> = Observable.create{ [weak base] observer in
            if let control = base {
                control.handler = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
   
}
extension Reactive where Base:UITableView{
    var endRefreshing: Binder<Bool> {
        return Binder(base) { tv, isEnd in
            if isEnd {
                tv.es.stopPullToRefresh()
            }
        }
    }
    var isNoMoreData:Binder<Bool>{
        return Binder(base){tv,isNoMore in
            if isNoMore{
                tv.es.noticeNoMoreData()
            }else {
                tv.es.stopLoadingMore()
            }
        }
    }
}
