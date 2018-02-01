
//
//  FoodCardsViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//


import Foundation
import ObjectMapper

class FoodCards: Mappable {
	var restaurant_info_id: String?
	var restaurant_name: String?
	var restaurantDishes: [RestaurantDishes]?

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        restaurant_info_id  <- map["restaurant_info_id"]
        restaurant_name     <- map["restaurant_name"]
        restaurantDishes    <- map["restaurantDishes"]
    }
}

class RestaurantDishes: Mappable {
    
    var restaurant_dish_id: String?
    var dish_image_url: String?
    var restaurantDishLabels: [RestaurantDishLabels]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        restaurant_dish_id     <- map["restaurant_dish_id"]
        dish_image_url         <- map["dish_image_url"]
        restaurantDishLabels   <- map ["restaurantDishLabels"]
    }
}

class RestaurantDishLabels: Mappable {
    
    var dish_label: String?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        dish_label <- map["dish_label"]
    }
}

