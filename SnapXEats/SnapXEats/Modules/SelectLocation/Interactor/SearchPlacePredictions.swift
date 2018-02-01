//
//  SearchPlacePredictions.swift
//  SnapXEats
//
//  Created by synerzip on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchPlacePredictions: Mappable {
    
    var palceList = [SearchPlace]()
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        palceList <- map["predictions"]
    }
}


class SearchPlace: Mappable {
    var id: String?
    var description: String?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        id            <- map["place_id"]
        description   <- map["description"]
    }
}
