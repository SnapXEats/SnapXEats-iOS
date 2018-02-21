//
//  RestaurantDetails.swift
//  SnapXEats
//
//  Created by synerzip on 20/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

class RestaurantDetailsItem: Mappable {
    var restaurantDetails: RestaurantDetails?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurantDetails        <- map["restaurantDetails"]
    }
}

class RestaurantDetails: Mappable {
    var id: String?
    var isOpenNow: Bool?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var contactNumber: String?
    var name: String?
    var photos = [RestaurantPhoto]()
    var price: Int?
    var rating: Double?
    var specialities = [RestaurantSpeciality]()
    var timings = [RestaurantTiming]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id             <- map["restaurant_info_id"]
        isOpenNow      <- map["isOpenNow"]
        latitude       <- map["location_lat"]
        longitude      <- map["location_long"]
        address        <- map["restaurant_address"]
        contactNumber   <- map["restaurant_contact_no"]
        name           <- map["restaurant_name"]
        photos         <- map["restaurant_pics"]
        price          <- map["restaurant_price"]
        rating         <- map["restaurant_rating"]
        specialities   <- map["restaurant_speciality"]
        timings        <- map["restaurant_timings"]
    }
}

class RestaurantPhoto: Mappable {
    var imageURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        imageURL        <- map["dish_image_url"]
    }
}

class RestaurantSpeciality: Mappable {
    var imageURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        imageURL        <- map["dish_image_url"]
    }
}

class RestaurantTiming: Mappable {
    var day: String?
    var time: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        day   <- map["day_of_week"]
        time  <- map["restaurant_open_close_time"]
    }
}
