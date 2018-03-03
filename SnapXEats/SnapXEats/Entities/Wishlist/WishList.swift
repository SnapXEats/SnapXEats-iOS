//
//  WishList.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 03/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class WishList: Mappable {
    var wishList: [WishListData]?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        wishList <- map["user_wishlist"]
    }
}

class WishListData: Mappable {
    
    var user_gesture_id = SnapXEatsConstant.emptyString
    var restaurant_info_id = SnapXEatsConstant.emptyString
    var restaurant_name = SnapXEatsConstant.emptyString
    var restaurant_address = SnapXEatsConstant.emptyString
    var dish_image_url = SnapXEatsConstant.emptyString
    var created_at = SnapXEatsConstant.emptyString
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        user_gesture_id     <- map["user_gesture_id"]
        restaurant_info_id  <- map["restaurant_info_id"]
        restaurant_name     <- map["restaurant_name"]
        restaurant_address  <- map["restaurant_address"]
        dish_image_url      <- map["dish_image_url"]
        created_at          <- map["created_at"]
    }
}
