//
//  FoodAndCusinePreference.swift
//  SnapXEats
//
//  Created by synerzip on 13/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

enum PreferenceType: Int {
    case cuisine = 0
    case food = 1
}

class PreferenceItem {
    var type: PreferenceType?
    var isLiked: Bool = true
    var isFavourite: Bool = true
    var itemID: String?
    
    init(type: PreferenceType) {
        self.type = type
    }
}

class FoodPreference: Mappable {
    var foodItems = [FoodItem]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        foodItems       <- map["foodTypeList"]
    }
}

class FoodItem: PreferenceItem, Mappable {
    var foodItemImageURL: String?
    var foodItemName: String?
    
    required init?(map: Map) {
        super.init(type: .food)
    }
    
    func mapping(map: Map) {
        itemID          <- map["food_type_info_id"]
        foodItemImageURL     <- map["food_image_url"]
        foodItemName        <- map["food_name"]
        isLiked             <- map["is_food_like"]
        isFavourite         <- map["is_food_favourite"]
    }
}
