
//
//  FoodCardsViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//


import Foundation
import ObjectMapper

class DishInfo: Mappable {

    var restaurants: [Restaurant]?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        restaurants <- map["dishesInfo"]
    }
}

class Restaurant: Mappable {
	var restaurant_info_id: String?
	var restaurant_name: String?
	var restaurantDishes =  [RestaurantDishes]()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var price: Int?
    var type: String?
    var logoImage: String?

    // This is temp Code to send restaurant Object to Checkin Popup
    init(id: String, name: String) {
        restaurant_info_id = id
        restaurant_name = name
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        restaurant_info_id  <- map["restaurant_info_id"]
        restaurant_name     <- map["restaurant_name"]
        restaurantDishes    <- map["restaurantDishes"]
        latitude           <- map["location_lat"]
        longitude          <- map["location_long"]
        price              <- map["restaurant_price"]
        type              <- map["restaurant_type"]
        logoImage         <- map["restaurant_logo"]
    }
}

class RestaurantDishes: Mappable {
    
    var restaurant_dish_id: String?
    var dish_image_url: String?
    var restaurantDishLabels = [DishLabels]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_dish_id     <- map["restaurant_dish_id"]
        dish_image_url         <- map["dish_image_url"]
        restaurantDishLabels   <- map ["restaurantDishLabels"]
    }
}

class DishLabels: Mappable {
    
    var dish_label: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        dish_label <- map["dish_label"]
    }
}

class RestaurantsList: Mappable {
    
    var restaurants = [Restaurant]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurants <- map["restaurants_info"]
    }
}

