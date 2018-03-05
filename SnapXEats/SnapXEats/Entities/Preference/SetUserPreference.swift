//
//  SetUserPrefernce.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 20/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//


import Foundation
import RealmSwift

class SetUserPreference: Object {
    
    @objc dynamic var userID = SnapXEatsConstant.emptyString
    @objc dynamic var ratingPreference = 0 // default is all rating
    @objc dynamic var pricingPreference = 1 // Default is 1 auto
    @objc dynamic var sortByPreference = 0
    @objc dynamic var distancePreference = 1 // default distance in 1 Mile
    let foodPreference = List<UserFoodPreference>()
    let cuisinePreference = List<UserCuisinePreference>()
    
    static func saveUserPrefernce(prefernce: SetUserPreference) {
        // Get the default Realm
        if prefernce.userID != SnapXEatsConstant.emptyString {
            if  let storedPrefernce = getUserPrefernce(userID: prefernce.userID)  {
                updateUserPrefernce(storedPreference: storedPrefernce, newPreference: prefernce)
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(prefernce)
            }
        }
    }
    
    static func resetFoodPreference(userID: String){
        if  let _ = getUserPrefernce(userID: userID), userID != SnapXEatsConstant.emptyString  {
            // Get the default Realm
            let realm = try! Realm()
            if let userPref = getUserPrefernce(userID: userID)  {
                try! realm.write {
                    userPref.foodPreference.removeAll()
                }
            }
        }
    }
    
    static func resetCuisinePreference(userID: String){
        if  let _ = getUserPrefernce(userID: userID), userID != SnapXEatsConstant.emptyString  {
            // Get the default Realm
            let realm = try! Realm()
            if let userPref = getUserPrefernce(userID: userID)  {
                try! realm.write {
                    userPref.cuisinePreference.removeAll()
                }
            }
        }
    }
    
    static func getUserPrefernce(userID: String) -> SetUserPreference?  {
        // Get the default Realm
        let realm = try! Realm()
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        // Query Realm for profile for which id is not empty
        let result: Results<SetUserPreference> = realm.objects(SetUserPreference.self).filter(predicate)
        return result.first
    }
    
    static func updateUserPrefernce(storedPreference: SetUserPreference, newPreference: SetUserPreference) {
        // Get the default Realm
        let realm = try! Realm()
        try! realm.write {
            storedPreference.ratingPreference   = newPreference.ratingPreference
            storedPreference.pricingPreference  = newPreference.pricingPreference
            storedPreference.sortByPreference   = newPreference.sortByPreference
            storedPreference.distancePreference = newPreference.distancePreference
        }
    }
    
    static func updateFoodPrefernce(userID: String, preferencesItems: [PreferenceItem]) {
        // Get the default Realm
        let realm = try! Realm()
        if let userPreference = getUserPrefernce(userID: userID) {
            let foodPreferences = userPreference.foodPreference
            try! realm.write {
                if foodPreferences.count > 0 {
                    for preferenceItem in preferencesItems {
                        var matched = false
                        for food in foodPreferences {
                            if let Id = preferenceItem.itemID, food.Id == Id {
                                food.like = preferenceItem.isLiked
                                food.favourite = preferenceItem.isFavourite
                                matched = true
                                break
                            }
                        }
                        if matched == false {
                            saveFoodPreferecne(foodPreferences: foodPreferences, preferenceItem: preferenceItem)
                        }
                        matched = false
                    }
                    
                } else {
                    for preferenceItem in preferencesItems {
                        saveFoodPreferecne(foodPreferences: foodPreferences, preferenceItem: preferenceItem)
                    }
                }
            }
        }
    }
    
    
    static func saveFoodPreferecne(foodPreferences: List<UserFoodPreference>, preferenceItem: PreferenceItem) {
        if let itemId = preferenceItem.itemID, preferenceItem.isLiked || preferenceItem.isFavourite {
            let foodItem = UserFoodPreference()
            foodItem.Id = itemId
            foodItem.like = preferenceItem.isLiked
            foodItem.favourite = preferenceItem.isFavourite
            foodPreferences.append(foodItem)
        }
    }
    
    static func updateCuisinePrefernce(userID: String, preferencesItems: [PreferenceItem]) {
        // Get the default Realm
        let realm = try! Realm()
        if let userPreference = getUserPrefernce(userID: userID) {
            let cuisinePreferences = userPreference.cuisinePreference
            try! realm.write {
                if cuisinePreferences.count > 0 {
                    for preferenceItem in preferencesItems {
                        var matched = false
                        for cuisine in cuisinePreferences {
                            if let Id = preferenceItem.itemID, cuisine.Id == Id {
                                cuisine.like = preferenceItem.isLiked
                                cuisine.favourite = preferenceItem.isFavourite
                                matched = true
                                break
                            }
                        }
                        if matched == false {
                            saveCuisinePreferecne(cuisinePreferences: cuisinePreferences, preferenceItem: preferenceItem)
                        }
                         matched = false
                    }
                    
                } else {
                    for preferenceItem in preferencesItems {
                        saveCuisinePreferecne(cuisinePreferences: cuisinePreferences, preferenceItem: preferenceItem)
                    }
                }
            }
        }
    }
    
    
    static func saveCuisinePreferecne(cuisinePreferences: List<UserCuisinePreference>, preferenceItem: PreferenceItem) {
        if let itemId = preferenceItem.itemID, preferenceItem.isLiked || preferenceItem.isFavourite {
            let cuisineItem = UserCuisinePreference()
            cuisineItem.Id = itemId
            cuisineItem.like = preferenceItem.isLiked
            cuisineItem.favourite = preferenceItem.isFavourite
            cuisinePreferences.append(cuisineItem)
        }
    }
    static func deleteStoredLogedInUser() {
        // Get the default Realm
        let realm = try! Realm()
        // Delete all objects from the realm
        try! realm.write {
            realm.deleteAll()
        }
    }
}

class Prefernces: Object {
    @objc dynamic var Id: String = SnapXEatsConstant.emptyString
    @objc dynamic var like = false
    @objc dynamic var favourite = false
    @objc dynamic var preferenceId: String = SnapXEatsConstant.emptyString
}

class UserFoodPreference: Prefernces {
}

class UserCuisinePreference: Prefernces {
}
