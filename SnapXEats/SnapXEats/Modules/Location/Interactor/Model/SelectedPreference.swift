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
        let lat =  NSDecimalNumber(floatLiteral: 40.4862157)
        let long = NSDecimalNumber(floatLiteral: -74.4518188)
        return (NSDecimalNumber(floatLiteral: 40.4862157).decimalValue, NSDecimalNumber(floatLiteral: -74.4518188).decimalValue)
    }
    static let singleInstance = SelectedPreference()
    private init() {
    }
}
