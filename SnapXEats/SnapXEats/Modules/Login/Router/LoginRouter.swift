//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import UIKit

class LoginRouter {
    
    // MARK: Properties
    
    weak var view: UIViewController?
    
    // MARK: Static methods
    
    static func setupModule() -> LoginViewController {
        
        let viewController = UIStoryboard.loadViewController() as LoginViewController
        
        let presenter = LoginPresenter()
      //  let router = LoginRouter()
       // let interactor = LoginInteractor()
        
        
        viewController.presenter =  presenter
        
        presenter.view = viewController
      //  presenter.router = router
       // presenter.interactor = interactor
        
      //  router.view = viewController
        
      //  interactor.output = presenter
        
        return viewController
    }
}


extension LoginRouter {  //LoginWireframe
    // TODO: Implement wireframe methods
}
