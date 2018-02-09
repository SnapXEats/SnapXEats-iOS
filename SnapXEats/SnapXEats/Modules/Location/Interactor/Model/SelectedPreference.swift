//
//  SelectedPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SelectedPreference {
    var location = SnapXEatsLocation ()
    var selectedCuisine = [String]()
    
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
