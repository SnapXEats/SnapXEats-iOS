//
//  Network.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum ServerErrorCode  {
    static let timeOut = -1001  // TIMED OUT:
    static let serverCanFound = -1003  // SERVER CANNOT BE FOUND
    static let urlNotFoundONServer = -1100  // URL NOT FOUND ON SERVER
    static let noInternetConnection = -1009  // No Internet connection
    static let loadingFiled = -999 // HTTP load failed
    
}

enum NetworkResult {
    case noInternet
    case error
    case fail
    case success(data: Any?)
    case cancelRequest
}

// MARK: - Notifications
enum SnapXEatsNotification {
    static let connectedToInternet = "ConnectedToInternet"
}
protocol SnapXEatsData {
    
}
protocol NetworkFailure: class {
    func noInternet(result: NetworkResult)
    func checkRechability() -> Bool
}

protocol SnapXResult: NetworkFailure {
    func success(result: Any?)
    func error(result: NetworkResult)
    func cancel (result: NetworkResult)
}
