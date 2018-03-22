//
//  InstagramLoginPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class InstagramLoginPresenter {

    var baseView: BaseView?
    var router: InstagramLoginWireframe?
    var interactor: InstagramLoginInteractorInput?
    
    private init() {}
    
    static let shared = InstagramLoginPresenter()
    
    func loginUsingInstagram() {
        router?.presentScreen(screen: .instagram)
    }
    
    func skipUserLogin() {
        presentFirstTimeUserScreen()
    }
    
    func showLocationScreen() {
        removeInstagramWebView()
        presentLocationScreen()
    }
}

extension InstagramLoginPresenter: InstagramLoginPresentation {
    
    func instagramLoginRequest(request: URLRequest) -> Bool {
        guard let interactor = interactor else {
            return false
        }
        return interactor.sendInstagramRequest(request: request)
    }
    
    func removeInstagramWebView() {
        router?.presentScreen(screen: .firstScreen)
    }
    
    func getInstagramUserData(completionHandler: @escaping ()-> ()) {
        interactor?.getInstagramUserData(completionHandler: completionHandler)
    }
}

extension InstagramLoginPresenter: InstagramLoginInteractorOutput {
    
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
    
    private func presentLocationScreen() {
        router?.presentScreen(screen: .location)
    }
    //TODO: Implement other methods from interactor->presenter here
}
