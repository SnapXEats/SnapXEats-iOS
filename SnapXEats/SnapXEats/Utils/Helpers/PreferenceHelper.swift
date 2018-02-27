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
        setPreference.sortByPreference = preference.sortByPreference?.rawValue ?? 0
        setPreference.userID = preference.loginUserID
        SetUserPreference.saveUserPrefernce(prefernce: setPreference)
    }
    
    func getUserPrefernce(userID: String) -> SetUserPreference? {
        return SetUserPreference.getUserPrefernce(userID: userID)
    }
    
    func updateFoodPreference(usierID: String, preferencesItems: [PreferenceItem]) {
        let foodPreferences = List<UserFoodPreference>()
        for preferenceItem in preferencesItems {
            let foodPreference = UserFoodPreference()
            if let itemId = preferenceItem.itemID {
                foodPreference.Id = itemId
                foodPreference.like = preferenceItem.isLiked
                foodPreference.favourite = preferenceItem.isFavourite
                foodPreference.preferenceId = preferenceItem.preferencesId
                foodPreferences.append(foodPreference)
            }
        }
        SetUserPreference.updateFoodPrefernce(userID: usierID, foodPreference: foodPreferences)
    }
    
    func updateCuisinePreference(usierID: String, preferencesItems: [PreferenceItem]) {
        let cuisinePreferences = List<UserCuisinePreference>()
        for preferenceItem in preferencesItems {
            let cuisinePreference = UserCuisinePreference()
            if let itemId = preferenceItem.itemID {
                cuisinePreference.Id = itemId
                cuisinePreference.like = preferenceItem.isLiked
                cuisinePreference.favourite = preferenceItem.isFavourite
                cuisinePreference.preferenceId = preferenceItem.preferencesId
                cuisinePreferences.append(cuisinePreference)
            }
        }
        SetUserPreference.updateCuisinePrefernce(userID: usierID, cuisinePreference: cuisinePreferences)
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
    
    func getJSONDataUserPrefernce(prefernce: SetUserPreference) -> [String: Any] {
        return [PreferecneConstant.restaurant_rating: prefernce.ratingPreference,
                PreferecneConstant.restaurant_price: prefernce.pricingPreference,
                PreferecneConstant.restaurant_distance: prefernce.distancePreference,
                PreferecneConstant.sort_by_rating: prefernce.sortByPreference == 0 ? true : false,
                PreferecneConstant.sort_by_distance: prefernce.sortByPreference == 1 ? true : false,
                PreferecneConstant.user_cuisine_preferences: getJSONDataCuisinePrefernce(cuisinePrerferecne: prefernce.cuisinePreference),
                PreferecneConstant.user_food_preferences: getJSONDataFoodPrefernce(foodPrerferecne: prefernce.foodPreference),
        ]
    }
    
    private func getJSONDataCuisinePrefernce(cuisinePrerferecne: List<UserCuisinePreference>) -> [[String:Any]] {
        var cuisinePref = [[String:Any]]()
        for  cuisine in cuisinePrerferecne {
            let pref: [String: Any] = [PreferecneConstant.food_type_info_id : cuisine.Id,
                                       PreferecneConstant.is_food_like : cuisine.favourite,
                                       PreferecneConstant.is_food_favourite : cuisine.like]
            cuisinePref.append(pref)
        }
        return cuisinePref
    }
    
    private func getJSONDataFoodPrefernce(foodPrerferecne: List<UserFoodPreference>) -> [[String:Any]] {
        var foodPref = [[String:Any]]()
        for  food in foodPrerferecne {
            let pref: [String: Any] = [PreferecneConstant.food_type_info_id : food.Id,
                                       PreferecneConstant.is_food_like : food.favourite,
                                       PreferecneConstant.is_food_favourite : food.like]
            foodPref.append(pref)
        }
        return foodPref
    }
}

