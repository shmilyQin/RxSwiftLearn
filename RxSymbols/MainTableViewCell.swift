//
//  MainTableViewCell.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/9/1.
//

import UIKit
import RxGesture
import RxSwift
class MainTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initInterface()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
//    addGes()
  }
  
  func initInterface(){
    contentView.addSubview(titleLabel)
//    addGes()
  }
  func addGes(){
    titleLabel.rx.tapGesture().subscribe { _ in
      print("点击了")
    }.disposed(by: disposeBag)
  }
  lazy var titleLabel: UILabel = {
    let value = UILabel(frame: CGRect(x: 12, y: 0, width: 200, height: 40))
    value.font = .systemFont(ofSize: 16)
    value.textColor = .black
    return value
  }()
}
