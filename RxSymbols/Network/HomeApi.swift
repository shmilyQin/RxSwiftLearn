//
//  HomeApi.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2021/6/2.
//

import Foundation
import Moya
enum HomeApi {
  case getIndex
  case getData
}
extension HomeApi {
  var path: String {
    switch self {
    case .getData:
      return "1"
    case .getIndex:
      return "2"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Task {
    return .requestPlain
  }
}
