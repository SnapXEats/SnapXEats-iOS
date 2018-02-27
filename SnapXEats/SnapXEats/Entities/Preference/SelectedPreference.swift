//
//  SelectedPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum RatingPreferences: Int {
    case threeStar = 3
    case fourStar = 4
    case fiveStar = 5
}

enum PricingPreference: Int {
    case auto = 1
    case single
    case double
    case tripple
    case quadraple
}

enum SortByPreference: Int {
    case distance = 0
    case rating = 1
}

class LoginUserPreferences {
    
    static let shared = LoginUserPreferences()
    private init() {}
    var ratingPreference: RatingPreferences?
    var pricingPreference: PricingPreference = .auto
    var sortByPreference: SortByPreference = .distance
    var distancePreference = 1 // default  distances  in 1 miles
    
    var foodPreference = [FoodItem]()
    var cuisinePreference = [CuisineItem]()
    
    var isDirtyPreference = false
    
    var isLoggedIn: Bool {
        return SnapXEatsLoginHelper.shared.isUserLoggedIn()
    }
    
    var loginUserID: String {
        return SnapXEatsLoginHelper.shared.getLoggedInUserID()
    }
    
    var loginServerToken: String? {
        return SnapXEatsLoginHelper.shared.getLoginUserServerToken()
    }
    
    var fbInstagramAccessToken: String? {
        return SnapXEatsLoginHelper.shared.getLoginUserFBInstagramAccessToken() 
    }
    
    var firstTimeUser: Bool {
        return SnapXEatsLoginHelper.shared.firstTimeUser() 
    }
    
    var loggedInUserPreference = { () -> SetUserPreference? in
        let loginUserID =  SnapXEatsLoginHelper.shared.getLoggedInUserID()
        return PreferenceHelper.shared.getUserPrefernce(userID: loginUserID)
    }
    
    func reset() {
        ratingPreference = nil
        pricingPreference = .auto
        sortByPreference = .distance
        distancePreference = 1
        isDirtyPreference = false
        foodPreference.removeAll()
        cuisinePreference.removeAll()
    }
}

class SelectedPreference {
    var location = SnapXEatsLocation ()
    var selectedCuisine = [String]()
    var loginUserPreference = LoginUserPreferences.shared
    func getLatitude() -> (Decimal, Decimal) {
        let lat  =  40.4862157
        let long = -74.4518188
        return (NSDecimalNumber(floatLiteral: lat).decimalValue, NSDecimalNumber(floatLiteral: long).decimalValue)
    }

    func reset() {
        location.latitude = 0.0
        location.longitude = 0.0
        location.locationName = SnapXEatsConstant.emptyString
        selectedCuisine.removeAll()
        loginUserPreference.reset()
    }
    
    static let shared = SelectedPreference()
    private init() {
    }
}
