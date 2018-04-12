//
//  SmartPhoto.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper

class SmartPhoto: Mappable {
    
    var  restaurant_dish_id =  SnapXEatsConstant.emptyString
    var restaurant_name =  SnapXEatsConstant.emptyString
    var restaurant_address =  SnapXEatsConstant.emptyString
    var dish_image_url =  SnapXEatsConstant.emptyString
    var pic_taken_date =  SnapXEatsConstant.emptyString
    var audio_review_url =  SnapXEatsConstant.emptyString
    var text_review =  SnapXEatsConstant.emptyString
    var restaurant_aminities =  [String]()

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_dish_id <- map["restaurant_dish_id"]
        restaurant_name <- map["restaurant_name"]
        restaurant_address <- map["restaurant_address"]
        dish_image_url  <- map["dish_image_url"]
        pic_taken_date  <- map["pic_taken_date"]
        audio_review_url    <- map["audio_review_url"]
        text_review <- map["text_review"]
        restaurant_aminities <- map["restaurant_aminities"]
    }
}

