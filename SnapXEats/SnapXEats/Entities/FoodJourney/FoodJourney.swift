//
//  FoodJourney.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class FoodJourney: Mappable {
    var userCurrentWeekHistory = [UserCurrentWeekHistory]()
    var userPastHistory = [UserPastHistory]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userCurrentWeekHistory <- map["userCurrentWeekHistory"]
        userPastHistory <- map["userPastHistory"]
    }
}

class UserCurrentWeekHistory: Mappable {
    var restaurant_info_id = SnapXEatsConstant.emptyString
    var restaurant_name = SnapXEatsConstant.emptyString
    var reward_point = 0
    var restaurant_address = SnapXEatsConstant.emptyString
    var formattedDate = SnapXEatsConstant.emptyString
    var restaurant_image_url = SnapXEatsConstant.emptyString
    var reward_dishes = [String]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_info_id <- map["restaurant_info_id"]
        restaurant_name <- map["restaurant_name"]
        reward_point <- map["reward_point"]
        restaurant_image_url <- map["restaurant_image_url"]
        restaurant_address <- map["restaurant_address"]
        reward_dishes <- map["reward_dishes"]
        formattedDate <- map["formattedDate"]
    }
}

class UserPastHistory: Mappable {
    var restaurant_info_id = SnapXEatsConstant.emptyString
    var restaurant_name = SnapXEatsConstant.emptyString
    var reward_point = 0
    var restaurant_address = SnapXEatsConstant.emptyString
    var formattedDate = SnapXEatsConstant.emptyString
    var restaurant_image_url = SnapXEatsConstant.emptyString
    var reward_dishes = [String]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_info_id <- map["restaurant_info_id"]
        restaurant_name <- map["restaurant_name"]
        reward_point <- map["reward_point"]
        restaurant_image_url <- map["restaurant_image_url"]
        restaurant_address <- map["restaurant_address"]
        reward_dishes <- map["reward_dishes"]
        formattedDate <- map["formattedDate"]
    }
}
