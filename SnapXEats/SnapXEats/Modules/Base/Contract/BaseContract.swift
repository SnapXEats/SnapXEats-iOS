//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

protocol BaseView: SnapXResult, SnapXDialogs, SnapXNotification {
    func initView()
}

@objc protocol SnapXSelector: class {
     func internetConnected()
}
protocol SnapXNotification: SnapXSelector {
    func registerNotification()
    func unRegisterNotification()   
}

extension SnapXNotification {
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(internetConnected), name: NSNotification.Name(rawValue: SnapXEatsNotification.connectedToInternet), object: nil)
    }
    
    func unRegisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }

}

protocol SnapXDialogs: class {
    func showLoading()
    func hideLoading()
    func showError(_ message: String?)
    func showMessage(_ message: String?, withTitle title: String?)
}

protocol RootWireFrame {
    func presentScreen(screen: Screens)
}

extension RootWireFrame {
    func presentScreen(screen: Screens) {
        RootRouter.shared.presentScreen(screens: screen)
    }
}

protocol Response: class {
    var baseView: BaseView? {set get}
    func response(result: NetworkResult)
}

extension Response {
    func response(result: NetworkResult) {
        baseView?.hideLoading()
        switch result {
        case .success(let value):
            baseView?.success(result: value)
        case .error:
            baseView?.error(result: .error)
        case .fail:
            baseView?.error(result: .error)
        case  .noInternet:
            baseView?.noInternet(result: .noInternet)
        case  .cancelRequest:
            baseView?.cancel(result: .cancelRequest)
        }
    }
}
