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
    case success
    case cancelRequest
}
protocol NetworkFailure {
    func resultNOInternet(result: NetworkResult)
}

protocol Response {
    func response(result: NetworkResult)
}

protocol SnapXResult: NetworkFailure {
    func resultSuccess(result: NetworkResult)
    func resultError(result: NetworkResult)
}

