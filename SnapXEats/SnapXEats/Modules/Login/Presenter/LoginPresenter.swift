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
        if let router = router, let interact = interactor, interact.checkRechability() == true {
           let  instaView = router.loadInstagramView()
            RootRouter.singleInstance.presentLoginInstagramScreen(instaView)
        }
    }
    
    func setView(view: LoginView) {
        self.view = view
    }

    //TODO: Implement other methods from presenter->view here
    
}

extension LoginPresenter: Result {
    
    func result(result: NetworkResult) {
        switch result {
        case .success:
            view?.resultSuccess(result: NetworkResult.success)
        case .error:
            view?.resultError(result: NetworkResult.error)
        case .fail:
            view?.resultError(result: NetworkResult.error)
        case  .noInternet:
            view?.resultNOInternet(result: NetworkResult.noInternet)
            
        }
    }
    
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
    
    func removeInstagramWebView() {
        RootRouter.singleInstance.presentFirstScreen()
        //router?.loadLoginModule()
    }
}
