//
//  FoodCardHelper.swift
//  SnapXEats
//
//  Created by synerzip on 26/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class FoodCardActionHelper {
    
    static let shared = FoodCardActionHelper ()
    private init() {}
    
    func getJSONDataForGestures(foodCardActions: FoodCardActions) -> [String: Any] {
        return [UserGestureJSONKeys.like_dish_array: getJSONDataForUserFoodItems(foodCardItem: foodCardActions.likedItems),
                UserGestureJSONKeys.dislike_dish_array: getJSONDataForUserFoodItems(foodCardItem: foodCardActions.disLikedItems),
                UserGestureJSONKeys.wishlist_dish_array: getJSONDataForUserFoodItems(foodCardItem: foodCardActions.wishListItems)]
    }
    
    func getJSONDataForUserFoodItems(foodCardItem: List<UserFoodCard>) -> [[String:Any]] {
        var foodItems = [[String:Any]]()
        for  foodCard in foodCardItem {
            let foodItem: [String: Any] = [UserGestureJSONKeys.restaurant_dish_id : foodCard.Id]
            foodItems.append(foodItem)
        }
        return foodItems
    }
    
    func resetLocalFoodCardActions() {
        let userID = LoginUserPreferences.shared.loginUserID
        FoodCardActions.resetLocalFoodCardActions(userID: userID)
    }
    
    func getCurrentActionsForUser() -> FoodCardActions? {
        let userID = LoginUserPreferences.shared.loginUserID
        return FoodCardActions.getCurrentActionsForUser(userID: userID)
    }
    
    func addToWishList(foodCardItem: UserFoodCard) {
        let userID = LoginUserPreferences.shared.loginUserID
        FoodCardActions.addToWishList(foodCardItem: foodCardItem, userID: userID)
    }
    
    func addToLikedList(foodCardItem: UserFoodCard) {
        let userID = LoginUserPreferences.shared.loginUserID
        FoodCardActions.addToLikedList(foodCardItem: foodCardItem, userID: userID)
    }
    
    func addToDisLikedList(foodCardItem: UserFoodCard) {
        let userID = LoginUserPreferences.shared.loginUserID
        FoodCardActions.addToDisLikedList(foodCardItem: foodCardItem, userID: userID)
    }
    
    func removeFromDislikeList(foodCardItem: UserFoodCard) {
        let userID = LoginUserPreferences.shared.loginUserID
        FoodCardActions.removeFromDislikeList(foodCardItem: foodCardItem, userID: userID)
    }
    
    func getWishlistCountForCurrentUser() -> Int {
        let userID = LoginUserPreferences.shared.loginUserID
        return FoodCardActions.getWishlistCountForUser(userID: userID)
    }
}
