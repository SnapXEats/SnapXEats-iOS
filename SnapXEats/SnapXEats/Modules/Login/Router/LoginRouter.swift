//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import UIKit

class LoginRouter {
    
    // MARK: Properties
    
    // weak var view: UIViewController?
    
    private init() {}
    static var singletenInstance = LoginRouter()
    // MARK: Static methods
}


extension LoginRouter: LoginViewWireframe {
    
    func loadLoginModule() -> LoginView {
        let viewController = UIStoryboard.loadViewController() as LoginViewController
        initView(viewController: viewController)
        return viewController
    }
    
    private  func initView(viewController: LoginView) {
        let presenter = LoginPresenter.singletenInstance
        viewController.presenter =  presenter
        let router = LoginRouter.singletenInstance
        let interactor = LoginInteractor.singletenInstance
        presenter.router = router
        presenter.interactor = interactor
        //router.view = viewController
        interactor.output = presenter
        interactor.view = viewController
    }
}
