//
//  StoredUserPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation



//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 22/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class FirstTimeUserPreference: Mappable {
    
    var userPreferences: StoredUserPreference?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        userPreferences <- map["userPreferences"]
    }
}
class StoredUserPreference: Mappable {

    var ratingPreference = PreferecneConstant.defaultRatingPreference
    var pricingPreference = PreferecneConstant.defaultPricePreference - 1 // because of the indexing we need to store it as 0 else UI will crash 
    var distancePreference = PreferecneConstant.defaultDistancePreference // default is 5 else it will crash app
    var sort_by_distance = false
    var sort_by_rating = false
    
    var foodPreference = [StoredFoodPreference]()
    var cuisinePreference = [StoredCuisinePreference]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ratingPreference    <- map["restaurant_rating"]
        pricingPreference   <- map["restaurant_price"]
        distancePreference  <- map["restaurant_distance"]
        sort_by_distance    <- map["sort_by_distance"]
        sort_by_rating      <- map["sort_by_rating"]
        foodPreference      <- map["userFoodPreferences"]
        cuisinePreference   <- map["userCuisinePreferences"]
    }

}

class StoredPreference {
    var Id: String?
    var isliked = false
    var isFavourite = false
    init() {}
}

class StoredFoodPreference: StoredPreference, Mappable {

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        Id                   <- map["food_type_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
    }
}

class StoredCuisinePreference: StoredPreference, Mappable {
    
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        Id                   <- map["cuisine_info_id"]
        isliked              <- map["is_cuisine_like"]
        isFavourite          <- map["is_cuisine_favourite"]
    }
}
