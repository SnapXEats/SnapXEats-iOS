//
//  Cuisine.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 19/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class CuisinePreference: Mappable {
    
    var cuisineList = [Cuisine]()
    
    var userSelectedCuisinePreference = [UserSelectedCuisinePreference]()
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        cuisineList <- map["cuisineList"]
    }
}

class UserSelectedCuisinePreference : Mappable {
    
    var cuisineList = [Cuisine]()
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        cuisineList <- map["userPreSelectedCuisines"]
    }
}
class Cuisine: PreferenceItem, Mappable {
        var cuisineId: String?
        var cuisineImageURL: String?
        var cuisineName: String?
        var cuisentImage: UIImage?
    
        required init?(map: Map) {
            super.init(type: .cuisine)
        }
    
        // Mappable
        func mapping(map: Map) {
            cuisineId             <- map["cuisine_info_id"]
            cuisineImageURL       <- map["cuisine_image_url"]
            cuisineName           <- map["cuisine_name"]
        }
    }
   

