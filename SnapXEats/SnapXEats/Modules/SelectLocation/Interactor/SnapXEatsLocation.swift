//
//  SnapXEatsLocation.swift
//  SnapXEats
//
//  Created by synerzip on 31/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper


class SnapXEatsPlaceDetails: Mappable {
    var placeResult: SnapXEatsPlaceResult?

    required init?(map: Map) {
    }

    // Mappable
    func mapping(map: Map) {
        placeResult   <- map["result"]
    }
}

class SnapXEatsPlaceResult: Mappable {
    var geometry: SnapXEatsGeometry?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        geometry   <- map["geometry"]
    }
}

class SnapXEatsGeometry: Mappable {
    var location: SnapXEatsLocation?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        location   <- map["location"]
    }
}


class SnapXEatsLocation: NSObject, Mappable {
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        latitude    <- map["lat"]
        longitude   <- map["lng"]
    }
}
