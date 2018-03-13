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

class StoredUserPreference: Mappable {

    var ratingPreference = 0
    var pricingPreference = 0
    var distancePreference = 0
    var sort_by_distance = false
    var sort_by_rating = false
    
    
    var foodPreference = [StoredFoodPreference]()
    var cuisinePreference = [StoredCuisinePreference]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        foodPreference      <- map["userCuisinePreferences"]
        cuisinePreference   <- map["userFoodPreferences"]
    }

}

class StoredPreferecne: Mappable {

    var Id: String?
    var isliked = false
    var isFavourite = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class StoredFoodPreference: StoredPreferecne {

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        Id                   <- map["food_type_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
    }
}

class StoredCuisinePreference: StoredPreferecne {
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        Id                   <- map["cuisine_info_id"]
        isliked              <- map["is_food_like"]
        isFavourite          <- map["is_food_favourite"]
    }
}
