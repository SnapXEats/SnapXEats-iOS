//
//  SnapXEatsNetworkManager.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 29/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation


import UIKit
import Alamofire

class SnapXEatsNetworkManager {
    
    // MARK: - Properties
    static let sharedInstance = SnapXEatsNetworkManager()
    
    var manager = NetworkReachabilityManager(host: "www.google.com")
    var isConnectedToInternet = false
    
    private init() {
        initialSetUp()
    }
    
    func initialSetUp() {
        
        manager?.listener = {[weak self] status in
            
            guard let weakSelf = self else { return }
            switch status {
            case .reachable(_):
                weakSelf.isConnectedToInternet = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SnapXEatsNotification.connectedToInternet), object: nil)
            case .notReachable:
                weakSelf.isConnectedToInternet = false
            case .unknown:
                weakSelf.isConnectedToInternet = false
            }
        }
    }
    
    /**
     Check for network availiablity
     
     - returns: Void
     */
    func startMonitoringNetwork() {
        manager?.startListening()
    }
    
    //For future use
    /**
     Check whether device is connected to WiFi or not
     
     - returns: Status
     */
    func isConnectedToWiFi() -> Bool {
        if let reachabilityManager = manager {
            return reachabilityManager.isReachableOnEthernetOrWiFi
        }
        return false
    }
    
    //For future use
    /**
     Check whether device is connected to WWAN or not
     
     - returns: Status
     */
    func isConnectedToWWAN() -> Bool {
        if let reachabilityManager = manager {
            return reachabilityManager.isReachableOnWWAN
        }
        return false
    }
}
