//
//  Network.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum NetworkResult {
    case noInternet
    case error
    case fail
    case success(data: Any?)
    case cancelRequest
}

protocol SnapXEatsData {
    
}
protocol NetworkFailure {
    func noInternet(result: NetworkResult)
}

protocol Response {
    func response(result: NetworkResult)
}

protocol SnapXResult: NetworkFailure {
    func success(result: Any?)
    func error(result: NetworkResult)
    func cancel (result: NetworkResult)
}
