

//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 22/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class UserPreferences: Mappable {
    var restaurant_rating = SnapXEatsConstant.emptyString
    var restaurant_price = SnapXEatsConstant.emptyString
    var restaurant_distance = SnapXEatsConstant.emptyString
    var sort_by_distance = true
    var sort_by_rating = true
    
    var foodPreference = [UserFoodPreferences]()
    var cuisinePreference = [UserCuisinePreferences]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_rating   <- map["restaurant_rating"]
        restaurant_price    <- map["restaurant_price"]
        restaurant_distance <- map["restaurant_distance"]
        sort_by_distance    <- map["sort_by_distance"]
        sort_by_rating      <- map["sort_by_rating"]
        foodPreference      <- map["user_food_preferences"]
    }
}

class UserFoodPreferences: Mappable {
    var food_type_info_id = SnapXEatsConstant.emptyString
    var isliked = true
    var isFavourite = true
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        food_type_info_id    <- map["food_type_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
    }
}

class UserCuisinePreferences: Mappable {
    var cuisine_info_id = SnapXEatsConstant.emptyString
    var isliked = true
    var isFavourite = true
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cuisine_info_id      <- map["cuisine_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
    }
}
