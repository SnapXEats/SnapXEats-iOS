//
//  FoodPreferencePresenter.swift
//  
//
//  Created by Durgesh Trivedi on 21/02/18.
//  
//

import Foundation
import ObjectMapper
import Alamofire

class FoodAndCuisinePreferencePresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: FoodAndCuisinePreferenceWireframe?
    var interactor: FoodAndCuisinePreferenceInteractorInput?
    
    static let shared = FoodAndCuisinePreferencePresenter()
    private init() {}
}

extension FoodAndCuisinePreferencePresenter: FoodAndCuisinePreferencePresentation {

     func savePreferecne(type: PreferenceType, usierID: String, preferencesItems: [PreferenceItem]) {
        interactor?.savePreferecne(type: type, usierID: usierID, preferencesItems: preferencesItems)
    }
    
    func getSavedPreferecne(usierID: String, type: PreferenceType, preferenceItems: [PreferenceItem]) {
        interactor?.getSavedPreferecne(usierID: usierID, type: type, preferenceItems: preferenceItems)
    }

    func preferenceItemRequest(preferenceType: PreferenceType) {
        interactor?.getPreferenceItems(preferenceType: preferenceType)
    }
    
    func presentFoodAndCuisinePreferences(preferenceType: PreferenceType, parent: UINavigationController) {
        router?.presentScreen(screen: .foodAndCusinePreferences(preferenceType: preferenceType, parentController: parent))
    }
}

extension FoodAndCuisinePreferencePresenter: FoodAndCuisinePreferenceInteractorOutput {
    // TODO: implement interactor output methods
}

