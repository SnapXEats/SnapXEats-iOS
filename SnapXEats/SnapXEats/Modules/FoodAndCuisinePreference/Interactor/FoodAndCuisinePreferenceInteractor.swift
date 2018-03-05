//
//  FoodPreferenceInteractor.swift
//  
//
//  Created by Durgesh Trivedi on 21/02/18.
//  
//

import Foundation
import ObjectMapper
import Alamofire

class FoodAndCuisinePreferenceInteractor {

    // MARK: Properties
    static let shared = FoodAndCuisinePreferenceInteractor()
    
    private init() {}

    var output: FoodAndCuisinePreferenceInteractorOutput?
}

extension FoodAndCuisinePreferenceInteractor: FoodAndCuisinePreferenceRequestFormatter {
    
    func getPreferenceItems(preferenceType: PreferenceType) {
        (preferenceType == .food) ? getFoodItemPreferences(forPath: SnapXEatsWebServicePath.foodtypesURL) : getCuisinePreferences(forPath: SnapXEatsWebServicePath.cuisinetypesURL)
    }
}

extension FoodAndCuisinePreferenceInteractor: FoodAndCuisinePreferenceWebService {
    func sendUserPreferences(forPath: String, withParameters: [String : Any]) {
        
    }

    func getFoodItemPreferences(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<FoodPreference>) in
            let foodPreferences = response.result
            self?.foodItemPreferenceDetails(data: foodPreferences)
        }
    }
    
    func getCuisinePreferences(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<CuisinePreference>) in
            let cuisinePreferences = response.result
            self?.cuisinePreferenceDetails(data: cuisinePreferences)
        }
    }
}

extension FoodAndCuisinePreferenceInteractor: FoodAndCuisinePreferenceObjectMapper {
    
    func foodItemPreferenceDetails(data: Result<FoodPreference>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
    
    func cuisinePreferenceDetails(data: Result<CuisinePreference>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}

extension FoodAndCuisinePreferenceInteractor: FoodAndCuisinePreferenceInteractorInput {
    func resetData(type: PreferenceType) {
        type == .cuisine ? PreferenceHelper.shared.resetCuisinePreferenceData()
            : PreferenceHelper.shared.resetFoodPreferenceData()
    }
    
    func savePreferecne(type: PreferenceType, usierID: String, preferencesItems: [PreferenceItem]) {
     type == .cuisine ? PreferenceHelper.shared.updateCuisinePreference(usierID: usierID, preferencesItems: preferencesItems)
                      : PreferenceHelper.shared.updateFoodPreference(usierID: usierID, preferencesItems: preferencesItems)
    }

     func getSavedPreferecne(usierID: String, type: PreferenceType, preferenceItems: [PreferenceItem]) {
        if  let preference =  PreferenceHelper.shared.getUserPrefernce(userID: usierID) {
        type == .cuisine ? PreferenceHelper.shared.setSavedCuisinePrefernce(savedPrefernce: preference, preferenceItems: preferenceItems)
        : PreferenceHelper.shared.setSavedFoodPrefernce(savedPrefernce: preference, preferenceItems: preferenceItems)
         output?.response(result: .success(data: true))
        }
    }

}
