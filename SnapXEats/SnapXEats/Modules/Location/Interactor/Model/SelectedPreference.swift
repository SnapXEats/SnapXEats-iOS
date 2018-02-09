//
//  SelectedPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum RatingPreferences: Int {
    case threeStar = 1
    case fourStar = 2
    case fiveStar = 3
}

enum PricingPreference: Int {
    case single = 1
    case double = 2
    case tripple = 3
    case quadraple = 4
}

enum SortByPreference {
    case distance
    case rating
}

class SelectedPreference {
    var location = SnapXEatsLocation ()
    var selectedCuisine = [String]()
    var ratingPreference: RatingPreferences = .threeStar
    var pricingPreference: PricingPreference = .single
    var sortByPreference: SortByPreference?
    var distancePreference = 0 // 0 is same as Auto. Other distances are in miles
    
    func getLatitude() -> (Decimal, Decimal) {
        let lat  =  40.4862157
        let long = -74.4518188
        return (NSDecimalNumber(floatLiteral: lat).decimalValue, NSDecimalNumber(floatLiteral: long).decimalValue)
    }

    func resetData() {
        location.latitude = 0.0
        location.longitude = 0.0
        location.locationName = ""
        selectedCuisine = [String]()
    }
    
    static let shared = SelectedPreference()
    private init() {
    }
}
