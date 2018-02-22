//
//  UserPreferenceContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol UserPreferenceView: BaseView {
    // TODO: Declare view methods
}

protocol UserPreferencePresentation: UserPreferenceUseCase {
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController)
}

protocol UserPreferenceUseCase: class {
    func saveUserPreference(selectedPreference: SelectedPreference)
    func getUserPreference(userID: String)
}

protocol UserPreferenceInteractorIntput {
    func saveUserPreference(selectedPreference: SelectedPreference)
    func getUserPreference(userID: String)
}

protocol UserPreferenceWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol UserPreferenceInteractorOutput: Response {
    
}
