//
//  InstagramLoginPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class InstagramLoginPresenter {

    var baseView: BaseView?
    var router: InstagramLoginWireframe?
    var interactor: InstagramLoginInteractorInput?
    var smartPhoto_Draft_Stored_id = getTimeInterval()  // This is stored when user newly taken photo get saved. and get reset every time 
    private init() {}
    
    static let shared = InstagramLoginPresenter()
    
    
    var userLoginForShared: Bool {
        if let view = baseView as? InstagramLoginViewController {
            return view.sharedLoginFromSkip
        }
        return false
    }
    
    var parentController: UINavigationController? {
        if let view = baseView as? InstagramLoginViewController {
            return view.parentController
        }
        return nil
    }
    
    func skipUserLogin() {
        presentFirstTimeUserScreen()
    }
}

extension InstagramLoginPresenter: InstagramLoginPresentation {
    
    
    func removeInstagramWebView(sharedLoginFromSkip: Bool, parentController: UINavigationController?) {
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
            if let parent = parentController, userLoginForShared  {
                router?.presentScreen(screen: .socialLoginFromLoginPopUp(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parent))
            } else {
                presentFirstTimeUserScreen()
            }
           
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
