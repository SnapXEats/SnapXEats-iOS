//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import MBProgressHUD
import ReachabilitySwift

class BaseViewController: UIViewController {

    // MARK: Properties
    
    var progressHUD: MBProgressHUD?
    
    var loginAlert = SnapXAlert.singleInstance
    
    fileprivate var internalScrollView: UIScrollView?
    
    var isProgressHUD = false
    // MARK: Methods
    
    func showLoading() {
        if isProgressHUD == false {
            isProgressHUD = true
            let topmostViewController = findTopmostViewController()
            progressHUD = MBProgressHUD.showAdded(to: topmostViewController.view, animated: true)
            progressHUD?.mode = MBProgressHUDMode.indeterminate
        }
    }
    
    func hideLoading() {
        if isProgressHUD {
            self.progressHUD?.hide(animated: true)
            isProgressHUD = false
        }
    }
    
    @objc func internetConnected() {
        // Sub class should have thre own implemetation
    }
    
    func showMessage(_ message: String?, withTitle title: String?) {
        let errorMessage = message ?? "GENERIC_ERROR_MESSAGE"
        let errorTitle = title ?? "ERROR"
        let errorController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorController, animated: true, completion: nil)
    }
    
    func showError(_ message: String?) {
        let errorMessage = message ?? "GENERIC_ERROR_MESSAGE"
        let errorController = UIAlertController(title: "TITLE_ERROR", message: errorMessage, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorController, animated: true, completion: nil)
    }
    
    func setupKeyboardNotifications(with scrollView: UIScrollView?) {
        internalScrollView = scrollView
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Keyboard Notifications
    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 15.0, right: 0.0)
        
        internalScrollView?.contentInset = contentInsets
        internalScrollView?.scrollIndicatorInsets = contentInsets
        
        var aRect = view.frame
        aRect.size.height -= keyboardSize.height
        guard let activeFieldPresent = findActiveTextField(view.subviews) else { return }
        
        if (!aRect.contains(activeFieldPresent.frame.origin))
        {
            internalScrollView?.scrollRectToVisible(activeFieldPresent.frame, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        internalScrollView?.contentInset = contentInsets
        internalScrollView?.scrollIndicatorInsets = contentInsets
    }
    
    func error(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: AlertTitle.errorTitle, message: AlertMessage.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func noInternet(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: AlertTitle.errorTitle, message: AlertMessage.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func success(result: Any?) {
        loginAlert.createAlert(alertTitle: AlertTitle.errorTitle, message: AlertMessage.messageSuccess,forView: self)
        loginAlert.show()
    }
    
    func cancel(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: AlertTitle.errorTitle, message: AlertMessage.cancelRequest,forView: self)
        loginAlert.show()
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
}
