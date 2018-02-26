//
//  FoodCardActions.swift
//  SnapXEats
//
//  Created by synerzip on 26/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class FoodCardActions: Object {
    
    @objc dynamic var userID = SnapXEatsConstant.emptyString
    var wishListItems = List<UserFoodCard>()
    var likedItems = List<UserFoodCard>()
    var disLikedItems = List<UserFoodCard>()
    
    static func getCurrentActionsForUser(userID: String) -> FoodCardActions? {
        // Get the default Realm
        let realm = try! Realm()
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        let result = realm.objects(FoodCardActions.self).filter(predicate)
        return result.first
    }
    
    static func addToWishList(foodCardItem: UserFoodCard, userID: String) {
        // Get the default Realm
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                let currentWishList = currentFoodCardActions.wishListItems
                
                let realm = try! Realm()
                try! realm.write {
                    currentWishList.append(foodCardItem)
                }
            } else {
                let currentWishList = List<UserFoodCard>()
                let foodCardaction = FoodCardActions()
                foodCardaction.userID = userID
                currentWishList.append(foodCardItem)
                foodCardaction.wishListItems = currentWishList
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(foodCardaction)
                }
            }
        }
    }
    
    static func addToLikedList(foodCardItem: UserFoodCard, userID: String) {
        // Get the default Realm
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                let currentLikedList = currentFoodCardActions.likedItems
                
                let realm = try! Realm()
                try! realm.write {
                    currentLikedList.append(foodCardItem)
                }
            } else {
                let currentLikedList = List<UserFoodCard>()
                let foodCardaction = FoodCardActions()
                foodCardaction.userID = userID
                currentLikedList.append(foodCardItem)
                foodCardaction.likedItems = currentLikedList
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(foodCardaction)
                }
            }
        }
    }
    
    static func addToDisLikedList(foodCardItem: UserFoodCard, userID: String) {
        // Get the default Realm
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                let currentDislikedList = currentFoodCardActions.disLikedItems
                
                let realm = try! Realm()
                try! realm.write {
                    currentDislikedList.append(foodCardItem)
                }
            } else {
                let currentDislikedList = List<UserFoodCard>()
                let foodCardaction = FoodCardActions()
                foodCardaction.userID = userID
                currentDislikedList.append(foodCardItem)
                foodCardaction.disLikedItems = currentDislikedList
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(foodCardaction)
                }
            }
        }
    }
    
    static func getWishlistCountForUser(userID: String) -> Int {
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                let currentWishList = currentFoodCardActions.wishListItems
                return currentWishList.count
            }
        }
        return 0
    }
}

class UserFoodCard: Object {
    @objc dynamic var Id: String = SnapXEatsConstant.emptyString
}
