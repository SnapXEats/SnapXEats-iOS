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
    
    func saveUserPrefernce(preference: SelectedPreference) {
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
                    return true
                }
                return false
            })
            
        }
    }
}
