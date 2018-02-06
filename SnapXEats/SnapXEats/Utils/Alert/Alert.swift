//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum LoginAlert {
    static var loginTitle = "Error"
    static var messageNoInternet = "SnapXEats required internet connection to process your request. Please enable your internet access."
    static var messageSuccess = "Request Succesful"
    static var loginError = "Server Error during process your request"
    static var cancelRequest = "User canceled request"
}
class SnapXAlert{
    private var alertSnapX: UIAlertController?
    
    private var view: UIViewController?
    private init() {}
    
    static var singleInstance = SnapXAlert()
    
    func createAlert(alertTitle: String, message: String, forView: UIViewController) {
        create(alertTitle: alertTitle, message: message, forView: forView)
        alertSnapX?.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    }
    
    func createAlert(alertTitle: String, message: String, forView: UIViewController, withAction: UIAlertAction) {
        create(alertTitle: alertTitle, message: message, forView: forView)
        alertSnapX?.addAction(withAction)
    }
    
    private func create(alertTitle: String, message: String, forView: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertSnapX = alert
        view = forView
    }
    
    func showLoationSettingDialog(forView: UIViewController, settingString: String, cancel : @escaping () -> ()) {
         create(alertTitle: SnapXEatsLocationConstant.locationAlertTitle, message: SnapXEatsLocationConstant.locationAlertMessage, forView: forView)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(SnapXButtonTitle.cancel, comment: ""), style: .cancel, handler: {(UIAlertAction) in
            cancel()
        })
        let settingsAction = UIAlertAction(title: NSLocalizedString(SnapXButtonTitle.settings, comment: ""), style: .default) { (UIAlertAction) in
            if let url = NSURL(string: settingString) as URL? {
                UIApplication.shared.openURL(url)
            }
        }
        alertSnapX?.addAction(cancelAction)
        alertSnapX?.addAction(settingsAction)
        show()
    }
    
    func show() {
        if let alert = alertSnapX, let alrtView = view {
            alrtView.present(alert, animated: true, completion: nil)
        }
    }
}
