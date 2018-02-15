//
//  UserPreferenceInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class UserPreferenceInteractor {

    // MARK: Properties
    var output: UserPreferenceInteractorOutput?
}


extension UserPreferenceInteractor: UserPreferenceRequestFormatter {
  
    func getPreferenceItems(preferenceType: PreferenceType) {
        (preferenceType == .food) ? getFoodItemPreferences(forPath: SnapXEatsWebServicePath.foodtypesURL) : getCuisinePreferences(forPath: SnapXEatsWebServicePath.cuisinetypesURL)
    }
}

extension UserPreferenceInteractor: UserPreferenceWebService {
    
    func getFoodItemPreferences(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<FoodTypeList>) in
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

extension UserPreferenceInteractor: UserPreferenceObjectMapper {
    
    func foodItemPreferenceDetails(data: Result<FoodTypeList>) {
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



extension UserPreferenceInteractor: UserPreferenceUseCase {
    // TODO: Implement use case methods
}
