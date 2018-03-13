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
    var selectedPreference = SelectedPreference.shared
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
        setPreference.ratingPreference = preference.ratingPreference.rawValue
        setPreference.sortByPreference = preference.sortByPreference.rawValue
        setPreference.userID = preference.loginUserID
        SetUserPreference.saveUserPrefernce(prefernce: setPreference)
    }
    
    func saveFirstTimeLoginPreferecne(storedPreferecne: StoredUserPreference) {
        let setPreference = SetUserPreference()
        setPreference.distancePreference = storedPreferecne.distancePreference
        setPreference.pricingPreference = storedPreferecne.pricingPreference
        setPreference.ratingPreference = storedPreferecne.ratingPreference
        if storedPreferecne.sort_by_rating {
             setPreference.sortByPreference = 1
        }
        
        if storedPreferecne.sort_by_distance {
            setPreference.sortByPreference = 0
        }

        SetUserPreference.saveUserPrefernce(prefernce: setPreference)
        
        var foodItems = [PreferenceItem] ()
        for foodPreference in  storedPreferecne.foodPreference {
             let food = PreferenceItem()
                food.itemID = foodPreference.Id
                food.isLiked = foodPreference.isliked
                food.isLiked = foodPreference.isFavourite
                foodItems.append(food)
        }
        
        updateFoodPreference(usierID: SnapXEatsLoginHelper.shared.getLoggedInUserID(), preferencesItems: foodItems)
        
        var cuisineItems = [PreferenceItem] ()
        for cuisinePreference in  storedPreferecne.cuisinePreference {
            let cuisine = PreferenceItem()
            cuisine.itemID = cuisinePreference.Id
            cuisine.isLiked = cuisinePreference.isliked
            cuisine.isLiked = cuisinePreference.isFavourite
            cuisineItems.append(cuisine)
        }
        
        updateCuisinePreference(usierID: SnapXEatsLoginHelper.shared.getLoggedInUserID(), preferencesItems: cuisineItems)
    }
    
    func getUserPrefernce(userID: String) -> SetUserPreference? {
        return SetUserPreference.getUserPrefernce(userID: userID)
    }
    
    func getStoredCuisneList() -> [CuisineItem] {
        if loginPreferecne.isLoggedIn {
            setUserCuisinePreferecne()
        }
        return loginPreferecne.cuisinePreference
        
    }
    
    func getStoredFoodList() -> [FoodItem] {
        if loginPreferecne.isLoggedIn {
            setUserFoodPreferecne()
        }
        return loginPreferecne.foodPreference
    }
    
    private func getUserSelectedCuisinePreferecne() -> List<UserCuisinePreference>? {
        if let userInfo = SetUserPreference.getUserPrefernce(userID: loginPreferecne.loginUserID) {
            return userInfo.cuisinePreference
        }
        return nil
    }
    
    private func getUserSelectedFoodPreferecne() -> List<UserFoodPreference>? {
        if let userInfo = SetUserPreference.getUserPrefernce(userID: loginPreferecne.loginUserID) {
            return userInfo.foodPreference
        }
        return nil
    }
    
    func updateFoodPreference(usierID: String, preferencesItems: [PreferenceItem]) {
        SetUserPreference.updateFoodPrefernce(userID: usierID, preferencesItems: preferencesItems)
    }
    
    func updateCuisinePreference(usierID: String, preferencesItems: [PreferenceItem]) {
        SetUserPreference.updateCuisinePrefernce(userID: usierID, preferencesItems: preferencesItems)
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
    
    func getJSONDataUserPrefernce() -> [String: Any] {
        getUserRatings() // for logged in user
        return [PreferecneConstant.restaurant_rating: loginPreferecne.ratingPreference.rawValue,
                PreferecneConstant.restaurant_price: getpriceNonLoogedInPrefercne(value: loginPreferecne.pricingPreference.rawValue),
                PreferecneConstant.restaurant_distance: loginPreferecne.distancePreference,
                PreferecneConstant.sort_by_distance: loginPreferecne.sortByPreference.rawValue == 0 ? true : false,
                PreferecneConstant.sort_by_rating: loginPreferecne.sortByPreference.rawValue == 1 ? true : false, // default true for distance
            PreferecneConstant.user_cuisine_preferences: getJSONDataCuisinePrefernce(),
            PreferecneConstant.user_food_preferences: getJSONDataFoodPrefernce(),
        ]
    }
    
    private func getUserRatings() {
        if let userinfo = SetUserPreference.getUserPrefernce(userID: loginPreferecne.loginUserID) {
            loginPreferecne.distancePreference = userinfo.distancePreference
            loginPreferecne.ratingPreference = RatingPreferences(rawValue: userinfo.ratingPreference) ?? .defaultStart
            loginPreferecne.sortByPreference = SortByPreference(rawValue: userinfo.sortByPreference) ?? .distance
            loginPreferecne.pricingPreference = PricingPreference(rawValue: userinfo.pricingPreference) ?? .auto
        }
    }
    
    private func getJSONDataCuisinePrefernce() -> [[String:Any]] {
        setUserCuisinePreferecne()  //for logged in user after user kill the app get from DB
        var cuisinePref = [[String:Any]]()
        for  cuisine in loginPreferecne.cuisinePreference {
            let pref: [String: Any] = [PreferecneConstant.cuisine_info_id : cuisine.itemID ?? "",
                                       PreferecneConstant.is_cuisine_like : cuisine.isLiked,
                                       PreferecneConstant.is_cuisine_favourite : cuisine.isFavourite]
            cuisinePref.append(pref)
        }
        return cuisinePref
    }
    
    private func getJSONDataFoodPrefernce() -> [[String:Any]] {
        setUserFoodPreferecne() //for logged in user after user kill the app get from DB
        var foodPref = [[String:Any]]()
        for  food in loginPreferecne.foodPreference {
            let pref: [String: Any] = [PreferecneConstant.food_type_info_id : food.itemID ?? "",
                                       PreferecneConstant.is_food_like : food.isLiked,
                                       PreferecneConstant.is_food_favourite : food.isFavourite]
            foodPref.append(pref)
        }
        return foodPref
    }
    
    
    private func setUserCuisinePreferecne() {
        if let storedCuisines = getUserSelectedCuisinePreferecne() {
            loginPreferecne.cuisinePreference.removeAll()
            for storecuisne in storedCuisines {
                let cuisine = CuisineItem()
                cuisine.itemID = storecuisne.Id
                cuisine.isLiked = storecuisne.like
                cuisine.isFavourite = storecuisne.favourite
                loginPreferecne.cuisinePreference.append(cuisine)
            }
        }
    }
    
    private func setUserFoodPreferecne() {
        if let storedCuisines = getUserSelectedFoodPreferecne() {
            loginPreferecne.foodPreference.removeAll()
            for storefood in storedCuisines {
                let food = FoodItem()
                food.itemID = storefood.Id
                food.isLiked = storefood.like
                food.isFavourite = storefood.favourite
                loginPreferecne.foodPreference.append(food)
            }
        }
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
        let lat = selectedPreference.getLatitude()
        
        if loginPreferecne.isLoggedIn {
            return [
                SnapXEatsWebServiceParameterKeys.latitude  : lat.0, //selectedPreferences?.location.latitude ?? 0.0,
                SnapXEatsWebServiceParameterKeys.longitude : lat.1,// selectedPreferences?.location.longitude ?? 0.0,
                SnapXEatsWebServiceParameterKeys.cuisineArray : selectedPreference.selectedCuisine,
                
            ]
        }
        return [:]
    }
    
    func createParameterNonLoggedInUser() -> [String: Any] {
        let lat = selectedPreference.getLatitude()
        return [
            SnapXEatsWebServiceParameterKeys.latitude  : lat.0, //selectedPreferences?.location.latitude ?? 0.0,
            SnapXEatsWebServiceParameterKeys.longitude : lat.1,// selectedPreferences?.location.longitude ?? 0.0,
            PreferecneConstant.restaurant_distance: loginPreferecne.distancePreference,
            PreferecneConstant.restaurant_price: getpriceNonLoogedInPrefercne(value: loginPreferecne.pricingPreference.rawValue),
            PreferecneConstant.restaurant_rating: loginPreferecne.ratingPreference.rawValue,
            PreferecneConstant.sort_by_distance: loginPreferecne.sortByPreference.rawValue == 0 ? true : false, // default true for distance
            PreferecneConstant.sort_by_rating: loginPreferecne.sortByPreference.rawValue == 1 ? true : false,
            SnapXEatsWebServiceParameterKeys.cuisineArray : selectedPreference.selectedCuisine,
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

