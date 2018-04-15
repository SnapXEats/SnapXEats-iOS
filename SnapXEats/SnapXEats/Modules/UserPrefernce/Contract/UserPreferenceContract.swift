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
     var presenter: UserPreferencePresentation? {get set}
}

protocol UserPreferencePresentation: UserPreferenceUseCase {
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController)
    func presnetScreen(screen: Screens, parent: UINavigationController)
}

protocol UserPreferenceUseCase: class {
    func saveUserPreference(loginUserPreferences: LoginUserPreferences)
    func getUserPreference(userID: String)
    func sendUserPreference(preference: LoginUserPreferences)
    func updateUserPreference(preference: LoginUserPreferences)
}

protocol UserPreferenceInteractorIntput: UserPreferenceRequestFormatter {
    func saveUserPreference(loginUserPreferences: LoginUserPreferences)
    func getUserPreference(userID: String)
}

protocol UserPreferenceWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol UserPreferenceInteractorOutput: Response {
    
}

protocol UserPreferenceRequestFormatter: class {
    func sendUserPreference(preference: LoginUserPreferences)
    func updateUserPreference(preference: LoginUserPreferences)
}

protocol UserPreferenceWebService: class {
    func sendUserPreferences(forPath: String, withParameters: [String: Any])
    func updateUserPreferences(forPath: String, withParameters: [String: Any])
}

protocol UserPreferenceObjectMapper: class {
    func userPreferenceResult(result: Bool)
}
