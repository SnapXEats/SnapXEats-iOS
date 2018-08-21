//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

class LoginPresenter {
    // MARK: Properties

    var baseView: BaseView?
    
    var router: LoginViewWireframe?
    
    var interactor: LoginInteractor?
    
    private init () {}
    static  var  singletenInstance = LoginPresenter()
}

extension LoginPresenter: LoginViewPresentation {

    func loginUsingInstagram() {
        router?.presentScreen(screen: .instagram(sharedLoginFromSkip: false, rootController: nil))
    }
    
    func loginUsingFaceBook() {
        interactor?.sendFaceBookLoginRequest(view: baseView)
    }
    
    func skipUserLogin() {
        presentFirstTimeUserScreen()
    }
}

extension LoginPresenter: LoginViewInteractorOutput {
    
    func response(result: NetworkResult) {
        baseView?.hideLoading()
        switch result {
        case .success(_):
                presentFirstTimeUserScreen()
        case .error:
            baseView?.error(result: NetworkResult.error)
        case .fail:
            baseView?.error(result: NetworkResult.error)
        case  .noInternet:
            baseView?.noInternet(result: NetworkResult.noInternet)
        case  .cancelRequest:
            baseView?.cancel(result: NetworkResult.cancelRequest)
            
        }
    }
    
    func onLoginReguestFailure(message: String) {
        baseView?.showError(message)
    }
    
    private func presentFirstTimeUserScreen() {
        router?.presentScreen(screen: .firsTimeUser)
    }
}
