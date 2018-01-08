//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

class LoginPresenter {
    // MARK: Properties
    var view: LoginView?
    
    var router: LoginViewWireframe?
    
    var interactor: LoginInteractor?

    private init () {}
    static  var  singletenInstance = LoginPresenter()
}

extension LoginPresenter: LoginViewPresentation {
    func loginUsingFaceBook() {
        interactor?.sendFaceBookLoginRequest(view: view)
    }
    
    func loginUsingInstagram() {
        if let instaView = router?.loadInstagramView() {
            RootRouter.singleInstance.presentLoginInstagramScreen(instaView)
        }
    }
    
    func doSomething() {
        view?.showMessage("I'm doing something!!", withTitle: "Hey")
    }
    
    //TODO: Implement other methods from presenter->view here
    
}

extension LoginPresenter: LoginViewInteractorOutput {
    
    func onLoginReguestFailure(message: String) {
        view?.showError(message)
    }
    //TODO: Implement other methods from interactor->presenter here
}

extension LoginPresenter: LoginViewPresentationInstagram {
    func instagramLoginRequest(request: URLRequest) -> Bool {
        guard let interactor = interactor else {
            return false
        }
       return interactor.sendInstagramRequest(request: request)
    }
}
