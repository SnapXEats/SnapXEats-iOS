//
//  FoodAndCusinePreference.swift
//  SnapXEats
//
//  Created by synerzip on 13/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum PreferenceType: Int {
    case cuisine = 0
    case food = 1
}

class PreferenceItem {
    var type: PreferenceType?
    var isLiked: Bool = false
    var isFavourite: Bool = false
    
    init(type: PreferenceType) {
        self.type = type
    }
}

class FoodItem: PreferenceItem {
    var foodItemId: String?
    var foodItemImageURL: String?
    var foodItemName: String?
    
    init(itemID: String, imageURL: String, itemName: String) {
        foodItemId = itemID
        foodItemImageURL = imageURL
        foodItemName = itemName
        super.init(type: .food)
    }
    
//    required init?(map: Map) {
//    }
//    // Mappable
//    func mapping(map: Map) {
//        cuisineId             <- map["cuisine_info_id"]
//        cuisineImageURL       <- map["cuisine_image_url"]
//        cuisineName           <- map["cuisine_name"]
//    }
}
