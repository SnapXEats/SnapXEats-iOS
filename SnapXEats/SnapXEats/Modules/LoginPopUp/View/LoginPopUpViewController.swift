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
    weak var rootController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        rootView.alpha = 0.0
    }
    
    @IBAction func fbLoginAction(_ sender: Any) {
        presenter?.loginFaceBook(view: self)
    }
    
    @IBAction func instagramLoginAction(_ sender: Any) {
        if let parent = rootController {
            presenter?.loginInstagram(parentController: parent)
        }
    }
    
    @IBAction func shareLaterAction(_ sender: Any) {
        // self.removeFromSuperview()
        if let id = restaurantID {
            presenter?.presentScreen(screen: .snapNShareHome(restaurantID: id))
        }
    }
    
    override func success(result: Any?) {
        if let result = result as? Bool, result == true, let navigationController = rootController, let id = restaurantID {
            presenter?.presentScreen(screen: .socialLoginFromLoginPopUp(parentController: navigationController))
        }
    }
}

extension LoginPopUpViewController: LoginPopUpView {
    func initView() {
        
    }
    
}
