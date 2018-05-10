//
//  CheckInRestaurant.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 03/05/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

 enum NSCoderKeys {
    static let restaurantId = "restaurantId"
    static let name = "name"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let price = "price"
    static let type = "type"
    static let logoImage = "logoImage"
}
class CheckInRestaurant {
    var restaurantId: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var price: Int?
    var type: String?
    var logoImage: String?
}
