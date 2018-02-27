//
//  DrawerPresenter.swift
//  
//
//  Created by Durgesh Trivedi on 22/02/18.
//  
//

import Foundation
import UIKit

class DrawerPresenter {

    static let shared = DrawerPresenter()
    private init() {}
    // MARK: Properties
    var baseView: BaseView?
    var router: DrawerWireframe?
    var interactor: DrawerUseCase?
}

extension DrawerPresenter: DrawerPresentation {
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState) {
        router?.presentScreen(screen: screen, drawerState: drawerState)
    }
    
    func presnetScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
}

extension DrawerPresenter: DrawerInteractorOutput {
    // TODO: implement interactor output methods
}

extension DrawerPresenter: DrawerInteractorIntput {
    // TODO: implement interactor output methods
}


extension DrawerPresenter {
    func saveUserPreference(loginUserPreferences: LoginUserPreferences) {
        interactor?.saveUserPreference(loginUserPreferences: loginUserPreferences)
    }
    
    func getUserPreference(userID: String) {
        interactor?.getUserPreference(userID: userID)
    }
    func sendUserPreference(preference: LoginUserPreferences) {
        interactor?.sendUserPreference(preference: preference)
    }
    func updateUserPreference(preference: LoginUserPreferences) {
        interactor?.updateUserPreference(preference: preference)
    }
}
