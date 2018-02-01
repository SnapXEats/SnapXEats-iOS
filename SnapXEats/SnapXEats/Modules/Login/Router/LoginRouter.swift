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
    
    func loadInstagramView() -> LoginView {
        return initInstagramView()
    }
    
    private  func initView(viewController: LoginView) {
        let presenter = LoginPresenter.singletenInstance
        viewController.presenter =  presenter
        presenter.setView(view: viewController)
        let router = LoginRouter.singletenInstance
        let interactor = LoginInteractor.singletenInstance
        presenter.router = router
        presenter.interactor = interactor
        // router.view = viewController
        interactor.output = presenter
    }
    
    private func initInstagramView() -> LoginView {
        let viewController = UIStoryboard.loadViewControler(storyBoardName: SnapXEatsStoryboard.loginStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.instagramViewControllerID) as! InstagramViewController
        initView(viewController: viewController)
        return viewController
    }
}
