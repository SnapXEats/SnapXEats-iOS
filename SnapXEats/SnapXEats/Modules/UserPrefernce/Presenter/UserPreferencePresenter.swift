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
    weak var view: UserPreferenceView?
    var router: UserPreferenceWireframe?
    var interactor: UserPreferenceRequestFormatter?
}

extension UserPreferencePresenter: UserPreferencePresentation {
    func preferenceItemRequest(preferenceType: PreferenceType) {
        interactor?.getPreferenceItems(preferenceType: preferenceType)
    }
}

extension UserPreferencePresenter: UserPreferenceInteractorOutput {
    
}

extension UserPreferencePresenter: FoodAndCuisinePreferencePresentation {
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController) {
        router?.presentScreen(screen: .foodAndCusinePreferences(preferenceType: preferenceType, parentController: parent))
    }
}
