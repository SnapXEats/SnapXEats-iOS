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
    let likedItems = List<UserFoodCard>()
    let disLikedItems = List<UserFoodCard>()
    
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
}

class UserFoodCard: Object {
    @objc dynamic var Id: String = SnapXEatsConstant.emptyString
}
