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
    
    var restaurant_item_id: String?
    var restaurant_name =  SnapXEatsConstant.emptyString
    var restaurant_address =  SnapXEatsConstant.emptyString
    var dish_image_url =  SnapXEatsConstant.emptyString
    var pic_taken_date =  SnapXEatsConstant.emptyString
    var audio_review_url =  SnapXEatsConstant.emptyString
    var text_review =  SnapXEatsConstant.emptyString
    var rating = 3 // This will not come from server SmartPhoto object is also used to save the data for SmartPhoto and Draft feature
    var smartPhoto_Draft_Stored_id: String? // This will not come from server SmartPhoto object is also used to save the data for SmartPhoto and Draft feature
    var restaurant_aminities =  [String]()

    init() {}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_item_id <- map["restaurant_dish_id"]
        restaurant_name <- map["restaurant_name"]
        restaurant_address <- map["restaurant_address"]
        dish_image_url  <- map["dish_image_url"]
        pic_taken_date  <- map["pic_taken_date"]
        audio_review_url    <- map["audio_review_url"]
        text_review <- map["text_review"]
        restaurant_aminities <- map["restaurant_aminities"]
    }
}

