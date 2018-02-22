
//
//  FoodPreferenceContract.swift
//  
//
//  Created by Durgesh Trivedi on 21/02/18.
//  
//

import Foundation
import ObjectMapper
import Alamofire

protocol FoodAndCuisinePreferenceView: BaseView {
        var presenter: FoodAndCuisinePreferencePresentation? { set get }
}

protocol FoodAndCuisinePreferencePresentation: FoodAndCuisinePreferenceUseCase {
         func preferenceItemRequest(preferenceType: PreferenceType)
}

protocol FoodAndCuisinePreferenceUseCase: class {
    func savePreferecne(type: PreferenceType, usierID: String, preferencesItems: [PreferenceItem])
    func getSavedPreferecne(usierID: String, type: PreferenceType, preferenceItems: [PreferenceItem])
}

protocol FoodAndCuisinePreferenceInteractorInput: FoodAndCuisinePreferenceRequestFormatter {
     func savePreferecne(type: PreferenceType, usierID: String, preferencesItems: [PreferenceItem])
     func getSavedPreferecne(usierID: String, type: PreferenceType, preferenceItems: [PreferenceItem])
}

protocol FoodAndCuisinePreferenceInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol FoodAndCuisinePreferenceWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol FoodAndCuisinePreferenceRequestFormatter: class {
    func getPreferenceItems(preferenceType: PreferenceType)
}

protocol FoodAndCuisinePreferenceWebService: class {
    func getFoodItemPreferences(forPath: String)
    func getCuisinePreferences(forPath: String)
}

protocol FoodAndCuisinePreferenceObjectMapper: class {
    func foodItemPreferenceDetails(data: Result<FoodPreference>)
    func cuisinePreferenceDetails(data: Result<CuisinePreference>)
}
