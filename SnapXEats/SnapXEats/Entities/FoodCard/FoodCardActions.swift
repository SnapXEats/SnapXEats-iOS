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
                    let hasItem = currentWishList.filter({ (foodCard) -> Bool in
                        foodCard.Id == foodCardItem.Id ? true : false
                    })
                    if hasItem.count == 0 {
                        currentWishList.append(foodCardItem)
                    }
                    
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
        var count = 0
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                for item in  currentFoodCardActions.wishListItems {
                    if !item.isDeleted  {count+=1}
                }
            }
        }
        return count
    }
    
    static func removeFromDislikeList(foodCardItem: UserFoodCard, userID: String) {
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                let currentDislikedList = currentFoodCardActions.disLikedItems
                let realm = try! Realm()
                try! realm.write {
                    for (index, item) in currentDislikedList.enumerated() {
                        if item.Id == foodCardItem.Id {
                            currentDislikedList.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    
    static func makeDirtyWishList(foodCardItem: WishListItem, userID: String) {
        if userID != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
                if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                    let currentWishList = currentFoodCardActions.wishListItems
                    let realm = try! Realm()
                    try! realm.write {
                        for item in currentWishList {
                            if item.Id == foodCardItem.restaurant_dish_id {
                                item.isDeleted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func deleteWishList(userID: String) {
        if userID != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
                if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                    let currentWishList = currentFoodCardActions.wishListItems
                    let realm = try! Realm()
                    try! realm.write {
                        for item in currentWishList {
                            if item.isDeleted == true {
                                if let index = currentWishList.enumerated().filter( { $0.element.Id == item.Id }).map({ $0.offset }).first {
                                    currentWishList.remove(at: index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func resetLocalFoodCardActions(userID: String) {
        if userID != SnapXEatsConstant.emptyString {
            if let currentFoodCardActions = getCurrentActionsForUser(userID: userID) {
                
                let realm = try! Realm()
                try! realm.write {
                    currentFoodCardActions.likedItems.removeAll()
                    currentFoodCardActions.disLikedItems.removeAll()
                }
            }
        }
    }
}

class UserFoodCard: Object {
    @objc dynamic var Id: String = SnapXEatsConstant.emptyString
    @objc dynamic var isDeleted: Bool = false
}
