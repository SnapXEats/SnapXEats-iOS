//
//  LoginPopUpPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LoginPopUpPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: LoginPopUpView?
    var router: LoginPopUpWireframe?
    var interactor: LoginPopUpInteractorInPut?
    
    private init() {}
    static let shared = LoginPopUpPresenter()
}

extension LoginPopUpPresenter: LoginPopUpPresentation {
    func loginFaceBook(view: UIViewController) {
        interactor?.sendLoginFaceBook(view: view )
    }
    
    func loginInstagram(parentController: UINavigationController) {
        router?.presentScreen(screen: .instagram(sharedLoginFromSkip: true, rootController: parentController))
        //interactor?.sendLoginInstagram()
    }
    
    func presentScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
    
    // TODO: implement presentation methods
}

extension LoginPopUpPresenter: LoginPopUpInteractorOutput {
    // TODO: implement interactor output methods
}
