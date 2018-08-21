//
//  LoginPopUpRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LoginPopUpRouter {
        
    private init() {}
    static let shared = LoginPopUpRouter()

    
    func loadLoginPopUpView() -> LoginPopUpViewController {
        let viewController = UIStoryboard.loadViewController() as LoginPopUpViewController
        let presenter = LoginPopUpPresenter.shared
        let router = LoginPopUpRouter.shared
        let interactor = LoginPopUpInteractor.shared
        
        viewController.presenter =  presenter
        
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.output = presenter
        
        return viewController
    }
}

extension LoginPopUpRouter: LoginPopUpWireframe {
    // TODO: Implement wireframe methods
}
