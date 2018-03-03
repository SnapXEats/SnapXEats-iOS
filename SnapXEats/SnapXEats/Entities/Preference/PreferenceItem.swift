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
    var isLiked: Bool = false
    var isFavourite: Bool = false
    var itemID: String?
    var preferencesId: String?
    var imageURL: String?
    var name: String?
    
    init() {}
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
    
    override init() {super.init()}
    required init?(map: Map) {
        super.init(type: .food)
    }
    
    func mapping(map: Map) {
        itemID              <- map["food_type_info_id"]
        imageURL            <- map["food_image_url"]
        name                <- map["food_name"]
        isLiked             <- map["is_food_like"]
        isFavourite         <- map["is_food_favourite"]
        preferencesId       <- map["user_food_preferences_id"]
        
    }
}

class CuisineItem: PreferenceItem, Mappable {
    override init() {super.init()}
    required init?(map: Map) {
        super.init(type: .cuisine)
    }
    
    // Mappable
    func mapping(map: Map) {
        itemID                <- map["cuisine_info_id"]
        imageURL              <- map["cuisine_image_url"]
        name                  <- map["cuisine_name"]
        isLiked               <- map["is_cuisine_like"]
        isFavourite           <- map["is_cuisine_favourite"]
        preferencesId         <- map["user_cuisine_preferences_id"]
    }
}
