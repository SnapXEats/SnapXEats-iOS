//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

class LoginPresenter {
    // MARK: Properties
    private var view: LoginView?
    
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
        if  let interact = interactor, interact.checkRechability() == true {
            router?.presentScreen(screen: .instagram)
        }
    }
    
    func skipUserLogin() {
        presentLocationScreen()
    }
    func setView(view: LoginView) {
        self.view = view
    }

    //TODO: Implement other methods from presenter->view here
    
}

extension LoginPresenter: Response {
    
    func response(result: NetworkResult) {
        switch result {
        case .success:
            presentLocationScreen()
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
    
    private func presentLocationScreen() {
        router?.presentScreen(screen: .location)
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
    
    func removeInstagramWebView() {
         router?.presentScreen(screen: .firstScreen)
    }
}
