//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class SnapNShare: Mappable {
    var restaurant_name: String?
    var restaurant_dish_id: String?
    var dish_image_url: String?
    var message: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_name     <- map["restaurant_name"]
        restaurant_dish_id  <- map["restaurant_dish_id"]
        dish_image_url      <- map["dish_image_url"]
        message             <- map["message"]
    }
}
