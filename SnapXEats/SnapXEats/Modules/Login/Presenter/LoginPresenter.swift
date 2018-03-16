//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

class LoginPresenter {
    // MARK: Properties
    var view: LoginView?
    var baseView: BaseView?
    
    var router: LoginViewWireframe?
    
    var interactor: LoginInteractor?
    
    private init () {}
    static  var  singletenInstance = LoginPresenter()
}

extension LoginPresenter: LoginViewPresentation {

    func loginUsingInstagram() {
        router?.presentScreen(screen: .instagram)
    }
    
    func loginUsingFaceBook() {
        interactor?.sendFaceBookLoginRequest(view: view)
    }
    
    func skipUserLogin() {
        presentFirstTimeUserScreen()
    }
}

extension LoginPresenter: LoginViewInteractorOutput {
    
    func response(result: NetworkResult) {
        self.view?.hideLoading()
        switch result {
        case .success(_):
                presentFirstTimeUserScreen()
        case .error:
            view?.error(result: NetworkResult.error)
        case .fail:
            view?.error(result: NetworkResult.error)
        case  .noInternet:
            view?.noInternet(result: NetworkResult.noInternet)
        case  .cancelRequest:
            view?.cancel(result: NetworkResult.cancelRequest)
            
        }
    }
    
    func onLoginReguestFailure(message: String) {
        view?.showError(message)
    }
    
    private func presentFirstTimeUserScreen() {
        router?.presentScreen(screen: .firsTimeUser)
    }
    
    private func presentLocationScreen() {
        router?.presentScreen(screen: .location)
    }
    //TODO: Implement other methods from interactor->presenter here
}
