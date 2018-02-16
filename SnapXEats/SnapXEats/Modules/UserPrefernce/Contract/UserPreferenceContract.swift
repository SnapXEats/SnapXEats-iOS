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

protocol UserPreferenceView: class, BaseView {
    // TODO: Declare view methods
}

protocol UserPreferencePresentation: class {
    func preferenceItemRequest(preferenceType: PreferenceType)
}

protocol UserPreferenceUseCase: class {
    // TODO: Declare use case methods
}

protocol UserPreferenceInteractorOutput: Response {
}

protocol UserPreferenceWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol UserPreferenceRequestFormatter: class {
    func getPreferenceItems(preferenceType: PreferenceType)
}

protocol UserPreferenceWebService: class {
    func getFoodItemPreferences(forPath: String)
    func getCuisinePreferences(forPath: String)
}

protocol UserPreferenceObjectMapper: class {
    func foodItemPreferenceDetails(data: Result<FoodTypeList>)
    func cuisinePreferenceDetails(data: Result<CuisinePreference>)
}


protocol FoodAndCuisinePreferencePresentation: class {
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController )
}
