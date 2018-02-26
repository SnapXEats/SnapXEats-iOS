

//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 22/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class UserPreferences {
    var restaurant_rating = SnapXEatsConstant.emptyString
    var restaurant_price = SnapXEatsConstant.emptyString
    var restaurant_distance = SnapXEatsConstant.emptyString
    var sort_by_distance = true
    var sort_by_rating = true
    
    var foodPreference = [UserFoodPreferences]()
    var cuisinePreference = [UserCuisinePreferences]()
    
    init() {}
    required init?(map: Map) {
    }
    

}

class UserFoodPreferences {
    var food_type_info_id = SnapXEatsConstant.emptyString
    var isliked = true
    var isFavourite = true
    var preferenceId = 0
    init() {}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        food_type_info_id    <- map["food_type_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
        preferenceId         <- map["user__preferences_id"]
    }
}

class UserCuisinePreferences: Mappable {
    var cuisine_info_id = SnapXEatsConstant.emptyString
    var isliked = true
    var isFavourite = true
    var preferecneId = 0
    
    init() {}
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cuisine_info_id      <- map["cuisine_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
        preferecneId         <- map["user__preferences_id"]
    }
}
