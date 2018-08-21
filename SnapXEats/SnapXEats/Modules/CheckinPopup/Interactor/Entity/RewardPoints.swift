//
//  RewardPoints.swift
//  SnapXEats
//
//  Created by synerzip on 23/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class RewardPoints: Mappable {
    var points = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        points        <- map["reward_point"]
    }
}
