//
//  PreferenceHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 20/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class PreferenceHelper {
    
    static let shared = PreferenceHelper ()
    var selectedPreferecne = SelectedPreference.shared
    var loginPreferecne = SelectedPreference.shared.loginUserPreference
    private init() {}
    
    func isFoodPreferenceSet(foodPreference: List<UserFoodPreference>) -> Bool {
        for foodPre in foodPreference {
            if foodPre.like || foodPre.favourite {
                return true
            }
        }
        return false
    }
    
    func isCuisinePreferenceSet(cuisinePreference: List<UserCuisinePreference>) -> Bool {
        for cuisinePre in cuisinePreference {
            if cuisinePre.like || cuisinePre.favourite {
                return true
            }
        }
        return false
    }
    
    func saveUserPrefernce(preference: LoginUserPreferences) {
        let setPreference = SetUserPreference()
        setPreference.distancePreference = preference.distancePreference
        setPreference.pricingPreference =  preference.pricingPreference.rawValue
        setPreference.ratingPreference = preference.ratingPreference?.rawValue ?? 0
        setPreference.sortByPreference = preference.sortByPreference.rawValue
        setPreference.userID = preference.loginUserID
        SetUserPreference.saveUserPrefernce(prefernce: setPreference)
    }
    
    func getUserPrefernce(userID: String) -> SetUserPreference? {
        return SetUserPreference.getUserPrefernce(userID: userID)
    }
    
    func getUserSelectedCuisinePreferecne() -> List<UserCuisinePreference>? {
        if let userInfo = SetUserPreference.getUserPrefernce(userID: loginPreferecne.loginUserID) {
            return userInfo.cuisinePreference
        }
        return nil
    }
    
    func updateFoodPreference(usierID: String, preferencesItems: [PreferenceItem]) {
        let foodPreferences = List<UserFoodPreference>()
        for preferenceItem in preferencesItems {
            let foodPreference = UserFoodPreference()
            if let itemId = preferenceItem.itemID, preferenceItem.isLiked == true || preferenceItem.isFavourite == true {
                foodPreference.Id = itemId
                foodPreference.like = preferenceItem.isLiked
                foodPreference.favourite = preferenceItem.isFavourite
                foodPreference.preferenceId = preferenceItem.preferencesId
                foodPreferences.append(foodPreference)
                saveFoodPreferecne(foodPref: foodPreference)
            }
        }
        SetUserPreference.updateFoodPrefernce(userID: usierID, foodPreference: foodPreferences)
    }
    
    private func saveCuisinePreferecne(cuisinePreferecne: UserCuisinePreference) {
        let cusinePrefercne: CuisineItem = CuisineItem()
        cusinePrefercne.itemID = cuisinePreferecne.Id
        cusinePrefercne.isLiked = cuisinePreferecne.like
        cusinePrefercne.isFavourite = cuisinePreferecne.favourite
        cusinePrefercne.preferencesId = cuisinePreferecne.preferenceId
        loginPreferecne.cuisinePreference.append(cusinePrefercne)
    }
    
    func updateCuisinePreference(usierID: String, preferencesItems: [PreferenceItem]) {
        let cuisinePreferences = List<UserCuisinePreference>()
        for preferenceItem in preferencesItems {
            let cuisinePreference = UserCuisinePreference()
            if let itemId = preferenceItem.itemID, preferenceItem.isLiked == true || preferenceItem.isFavourite == true {
                cuisinePreference.Id = itemId
                cuisinePreference.like = preferenceItem.isLiked
                cuisinePreference.favourite = preferenceItem.isFavourite
                cuisinePreference.preferenceId = preferenceItem.preferencesId
                cuisinePreferences.append(cuisinePreference)
                saveCuisinePreferecne(cuisinePreferecne: cuisinePreference) 
            }
        }
        SetUserPreference.updateCuisinePrefernce(userID: usierID, cuisinePreference: cuisinePreferences)
    }
    
    private func saveFoodPreferecne(foodPref: UserFoodPreference) {
        let fooPrefercne: FoodItem = FoodItem()
        fooPrefercne.itemID = foodPref.Id
        fooPrefercne.isLiked = foodPref.like
        fooPrefercne.isFavourite = foodPref.favourite
        fooPrefercne.preferencesId = foodPref.preferenceId
        loginPreferecne.foodPreference.append(fooPrefercne)
    }
    
    func setSavedFoodPrefernce(savedPrefernce: SetUserPreference, preferenceItems: [PreferenceItem]){
        let foodPrefernces = savedPrefernce.foodPreference
        for foodPrefernce in foodPrefernces {
            let _ =  preferenceItems.filter({ (preferenceItem) -> Bool in
                if  foodPrefernce.Id == preferenceItem.itemID {
                    preferenceItem.isLiked = foodPrefernce.like
                    preferenceItem.isFavourite = foodPrefernce.favourite
                    preferenceItem.preferencesId = foodPrefernce.preferenceId
                    return true
                }
                return false
            })
            
        }
    }
    
    func setSavedCuisinePrefernce(savedPrefernce: SetUserPreference, preferenceItems: [PreferenceItem]){
        let cuisinePreferences = savedPrefernce.cuisinePreference
        for cuisinePreference in cuisinePreferences {
            let _ =  preferenceItems.filter({ (preferenceItem) -> Bool in
                if  cuisinePreference.Id == preferenceItem.itemID {
                    preferenceItem.isLiked = cuisinePreference.like
                    preferenceItem.isFavourite = cuisinePreference.favourite
                    preferenceItem.preferencesId = cuisinePreference.preferenceId
                    return true
                }
                return false
            })
            
        }
    }
    
    func getJSONDataUserPrefernce() -> [String: Any] {
        return [PreferecneConstant.restaurant_rating: loginPreferecne.ratingPreference?.rawValue ?? 0,
                PreferecneConstant.restaurant_price: getpriceNonLoogedInPrefercne(value: loginPreferecne.pricingPreference.rawValue),
                PreferecneConstant.restaurant_distance: loginPreferecne.distancePreference,
                PreferecneConstant.sort_by_distance: loginPreferecne.sortByPreference.rawValue == 0 ? true : false,
                PreferecneConstant.sort_by_rating: loginPreferecne.sortByPreference.rawValue == 1 ? true : false, // default true for distance
                PreferecneConstant.user_cuisine_preferences: getJSONDataCuisinePrefernce(),
                PreferecneConstant.user_food_preferences: getJSONDataFoodPrefernce(),
        ]
    }
    
    
    private func getJSONDataCuisinePrefernce() -> [[String:Any]] {
        var cuisinePref = [[String:Any]]()
        for  cuisine in loginPreferecne.cuisinePreference {
            let pref: [String: Any] = [PreferecneConstant.food_type_info_id : cuisine.itemID ?? "",
                                       PreferecneConstant.is_food_like : cuisine.isLiked,
                                       PreferecneConstant.is_food_favourite : cuisine.isFavourite]
            cuisinePref.append(pref)
        }
        return cuisinePref
    }
    
    private func getJSONDataFoodPrefernce() -> [[String:Any]] {
        var foodPref = [[String:Any]]()
        for  food in loginPreferecne.foodPreference {
            let pref: [String: Any] = [PreferecneConstant.food_type_info_id : food.itemID ?? "",
                                       PreferecneConstant.is_food_like : food.isLiked,
                                       PreferecneConstant.is_food_favourite : food.isFavourite]
            foodPref.append(pref)
        }
        return foodPref
    }
    
    private func getFoodPreferenceIdArray() -> [String] {
        var preferecne = [String]()
        for food in loginPreferecne.foodPreference {
            if let id = food.itemID {
                preferecne.append(id)
            }
        }
        return preferecne
    }
    
    private func getLoggedInUserFoodPreferenceIdArray(foodPreferecne: List<UserFoodPreference>) -> [String] {
        var preferecne = [String]()
        for food in foodPreferecne {
            preferecne.append(food.Id)
        }
        return preferecne
    }
    
    private func getNonLoggedInUserFoodPreferenceIdArray(foodPreferecne: [FoodItem]) -> [String] {
        var preferecne = [String]()
        for food in foodPreferecne {
            if let id = food.itemID {
                preferecne.append(id)
            }
        }
        return preferecne
    }
    
    private func getCuisinePreferenceIdArray() -> [String] {
        var preferecne = [String]()
        for cuisine in loginPreferecne.cuisinePreference {
            if let id = cuisine.itemID {
                preferecne.append(id)
            }
        }
        return preferecne
    }
    
    private func getpriceNonLoogedInPrefercne(value: Int) -> Int {
        return loginPreferecne.pricingPreference.rawValue - 1  // The index start in view from 1 but server need it from 0 and in view defualt index for any Tag for view start with 0 and it was creating problem
    }
    
     func createParameterLoggedInUser() -> [String: Any] {
        let lat = selectedPreferecne.getLatitude()
        
        if loginPreferecne.isLoggedIn {
            return [
                SnapXEatsWebServiceParameterKeys.latitude  : lat.0, //selectedPreferences?.location.latitude ?? 0.0,
                SnapXEatsWebServiceParameterKeys.longitude : lat.1,// selectedPreferences?.location.longitude ?? 0.0,
                SnapXEatsWebServiceParameterKeys.cuisineArray : selectedPreferecne.selectedCuisine,

            ]
        }
        return [:]
    }
    
    func createParameterNonLoggedInUser() -> [String: Any] {
        let lat = selectedPreferecne.getLatitude()
            return [
                SnapXEatsWebServiceParameterKeys.latitude  : lat.0, //selectedPreferences?.location.latitude ?? 0.0,
                SnapXEatsWebServiceParameterKeys.longitude : lat.1,// selectedPreferences?.location.longitude ?? 0.0,
                PreferecneConstant.restaurant_distance: loginPreferecne.distancePreference,
                PreferecneConstant.restaurant_price: getpriceNonLoogedInPrefercne(value: loginPreferecne.pricingPreference.rawValue),
                PreferecneConstant.restaurant_rating: loginPreferecne.ratingPreference?.rawValue ?? 0,
                PreferecneConstant.sort_by_distance: loginPreferecne.sortByPreference.rawValue == 0 ? true : false, // default true for distance
                PreferecneConstant.sort_by_rating: loginPreferecne.sortByPreference.rawValue == 1 ? true : false,
                SnapXEatsWebServiceParameterKeys.cuisineArray : selectedPreferecne.selectedCuisine,
                SnapXEatsWebServiceParameterKeys.foodArray: getNonLoggedInUserFoodPreferenceIdArray(foodPreferecne: loginPreferecne.foodPreference)
            ]
    }
    
    func resetFoodPreferenceData() {
        let userId = loginPreferecne.loginUserID
        SetUserPreference.resetFoodPreference(userID: userId)
    }
    
    func resetCuisinePreferenceData() {
        let userId = loginPreferecne.loginUserID
        SetUserPreference.resetCuisinePreference(userID: userId)
    }
}

