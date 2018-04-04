//
//  LoginPopUpViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LoginPopUpViewController: BaseViewController, StoryboardLoadable {
    
    var presenter: LoginPopUpPresentation?
    var restaurantID: String?
    @IBOutlet var rootView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var instagramLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        rootView.alpha = 0.0
    }
    
    @IBAction func fbLoginAction(_ sender: Any) {
        presenter?.loginFaceBook(view: self)
    }
    
    @IBAction func instagramLoginAction(_ sender: Any) {
        presenter?.loginInstagram()
    }
    
    @IBAction func shareLaterAction(_ sender: Any) {
       // self.removeFromSuperview()
        if let id = restaurantID {
            presenter?.presentScreen(screen: .snapNShareHome(restaurantID: id))
        }
    }
}

extension LoginPopUpViewController: LoginPopUpView {
    func initView() {
        
    }
    
    
}
