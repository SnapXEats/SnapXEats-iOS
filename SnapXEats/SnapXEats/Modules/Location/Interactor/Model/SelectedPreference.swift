//
//  SelectedPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SelectedPreference {
    var location = SnapXEatsLocation()
    var selectedCuisine = [String]()
    
    func getLatitude() -> (Double, Double) {
        return (0, 0)
    }
}
