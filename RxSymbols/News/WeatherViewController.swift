//
//  WeatherViewController.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/2.
//

import UIKit
import HandyJSON
class WeatherViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    lyApiProvider.rx.LYRequest(.getWeather).mapMode(WeatherModelB.self, designatedPath: "result.realtime")
      .subscribe { result in
        print(result)
    } onError: { error in
      print(error)
    }.disposed(by: disposeBag)
    
  }
}
class WeatherModel: HandyJSON {
  required init() {
    
  }
  var temperature = ""
  var aqi = ""
}

class WeatherModelB: HandyJSON {
  required init() {
    
  }
  var name = ""
}
