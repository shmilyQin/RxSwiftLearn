//
//  NetworkError.swift
//  RxSymbols
//
//  Created by 覃孙波 on 2023/7/7.
//

import Foundation
enum NetworkError: Error {
    case parseError
    case other(String)
}
