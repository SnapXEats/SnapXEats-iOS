//
//  UserPreferenceContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol UserPreferenceView: class, BaseView {
    // TODO: Declare view methods
}

protocol UserPreferencePresentation: class {
    // TODO: Declare presentation methods
}

protocol UserPreferenceUseCase: class {
    // TODO: Declare use case methods
}

protocol UserPreferenceInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol UserPreferenceWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol FoodAndCuisinePreferencePresentation: class {
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController )
}
