//
//  DrivingDirections.swift
//  SnapXEats
//
//  Created by synerzip on 23/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class DrivingDirections: Mappable {
    var routes = [Route]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        routes        <- map["routes"]
    }
}

class Route: Mappable {
    var legs = [Leg]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        legs        <- map["legs"]
    }
}

class Leg: Mappable {
    var duration: Duration?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        duration        <- map["duration"]
    }
}

class Duration: Mappable {
    var text: String = ""
    var value: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        text        <- map["text"]
        value        <- map["value"]
    }
}


