//
//  UserPreferencePresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class UserPreferencePresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    var router: UserPreferenceWireframe?
    var interactor: UserPreferenceInteractorIntput?
    static let shared = UserPreferencePresenter()
    private init() {}
}

extension UserPreferencePresenter: UserPreferencePresentation {

    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController) {
        router?.presentScreen(screen: .foodAndCusinePreferences(preferenceType: preferenceType, parentController: parent))
    }
    
    func presnetScreen(screen: Screens, parent: UINavigationController) {
        router?.presentScreen(screen: .location)
    }
}

extension UserPreferencePresenter: UserPreferenceInteractorOutput {
}

extension UserPreferencePresenter {
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
