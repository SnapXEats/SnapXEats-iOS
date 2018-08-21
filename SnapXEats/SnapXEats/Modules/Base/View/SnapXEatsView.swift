//
//  SnapXEatsView.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import MBProgressHUD

class SnapXEatsView: UIView {
    
    var progressHUD: MBProgressHUD?
    var isProgressHUD = false
    var loginAlert = SnapXAlert.singleInstance
    
    func initView() {
    }
    
    func error(result: NetworkResult) {
    }
    
    func noInternet(result: NetworkResult) {
    }
    
    func success(result: Any?) {
    }
    
    func cancel(result: NetworkResult) {
    }
    
    func checkRechability() -> Bool {
        if SnapXEatsNetworkManager.shared.isConnectedToInternet  == false {
            hideLoading()
            noInternet(result: .noInternet)
            return false
        } else {
            return true
        }
    }
    
    func showLoading() {
        if isProgressHUD == false {
            isProgressHUD = true
            if let window = UIApplication.shared.keyWindow {
                progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
                progressHUD?.mode = MBProgressHUDMode.indeterminate
            }
        }
    }
    
    func hideLoading() {
        if isProgressHUD {
            self.progressHUD?.hide(animated: true)
            isProgressHUD = false
        }
    }
    
    func showError(_ message: String?) {
    }
    
    func showMessage(_ message: String?, withTitle title: String?) {
    }
    
    @objc func internetConnected() {
    }

}
