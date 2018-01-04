//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation


class LoginPresenter {
    
    // MARK: Properties
    
    weak var view: LoginView?
    //var router: LoginViewWireframe?
    var interactor: LoginInteractor?
    
}

extension LoginPresenter: LoginViewPresentation {
    func loginUsingFaceBook() {
        interactor?.sendInstagramRequest(userName: "", pwd: "")
    }
    
    func loginUsingInstagram() {
        
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
