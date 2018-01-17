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
    static var loginTitle = "Login"
    static var messageNoInternet = "You can't login check the Internet first"
    static var messageSuccess = "Login Succesful"
    static var loginError = "Server Error in login"
    static var cancelRequest = "Login Canceled"
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
    
    
    func show() {
        if let alert = alertSnapX, let alrtView = view {
            alrtView.present(alert, animated: true, completion: nil)
        }
    }
}
