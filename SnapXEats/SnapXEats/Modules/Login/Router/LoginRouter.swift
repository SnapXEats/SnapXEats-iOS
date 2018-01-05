//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import UIKit

class LoginRouter {
    
    // MARK: Properties
    
    weak var view: UIViewController?
    
    private init() {}
    static var singletenInstance = LoginRouter()
    // MARK: Static methods
    
    static func setupModule() -> LoginViewController {
        
        let viewController = UIStoryboard.loadViewController() as LoginViewController
        
        let presenter = LoginPresenter.singletenInstance
        let router = singletenInstance
        let interactor = LoginInteractor.singletenInstance
        
        
        viewController.presenter =  presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return viewController
    }
}


extension LoginRouter: LoginViewWireframe {
    // TODO: Implement wireframe methods
}
