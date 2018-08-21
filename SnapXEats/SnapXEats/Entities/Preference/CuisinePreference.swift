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
    
    var cuisineList = [CuisineItem]()
    
    var userSelectedCuisinePreference = [UserSelectedCuisinePreference]()
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        cuisineList <- map["cuisineList"]
    }
}

class UserSelectedCuisinePreference : Mappable {
    
    var cuisineList = [CuisineItem]()
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        cuisineList <- map["userPreSelectedCuisines"]
    }
}
