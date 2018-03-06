//
//  RestaurantDetails.swift
//  SnapXEats
//
//  Created by synerzip on 20/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper

private enum restaurantTimingConstants {
    static let open = "Open Today"
    static let close = "Closed Now"
}

private let weekDays = ["Monday": 1, "Tuesday":2, "Wednesday":3, "Thursday":4, "Friday":5, "Saturday":6, "Sunday":7]

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
    var restaurant_amenities = [String]()
    
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
        latitude      <- map["location_lat"]
        longitude      <- map["location_long"]
        restaurant_amenities  <- map["restaurant_amenities"]
    }
    
    func timingDisplayText() -> String {
        var timingStr = SnapXEatsAppDefaults.emptyString
        if self.isOpenNow == false {
            return restaurantTimingConstants.close
        } else if self.isOpenNow == true {
            let today = Date().dayOfWeek()
            for timing in self.timings {
                if timing.day == today {
                    timingStr = timing.time ?? SnapXEatsAppDefaults.emptyString
                }
            }
            return restaurantTimingConstants.open + " " + timingStr
        }
        return SnapXEatsAppDefaults.emptyString
    }
    
    func sortedRestaurantTimings() -> [RestaurantTiming]? {
        let sortedTimings = self.timings.sorted(by: { (item1, item2) -> Bool in
            if let weekdayInt1 = weekDays[item1.day!], let weekdayInt2 = weekDays[item2.day!] {
                return weekdayInt1 < weekdayInt2
            }
            return false
        })
        return sortedTimings
    }
}

class RestaurantPhoto: Mappable {
    var imageURL: String?
    var createDate: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        imageURL        <- map["dish_image_url"]
        createDate      <- map["created_date"]
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
