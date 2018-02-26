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
    var pricingPreference: PricingPreference = .single
    var sortByPreference: SortByPreference?
    var distancePreference = 0 // 0 is same as Auto. Other distances are in miles
    
    var foodPreference = [FoodItem]()
    var cuisinePreference = [CuisineItem]()
    
    var isDirtyPreference = false
    
     var isLoggedIn = {
        return SnapXEatsLoginHelper.shared.isUserLoggedIn()
    }()
    
    var loginUserID = {
        return SnapXEatsLoginHelper.shared.getLoggedInUserID()
    }()
    
    var loginServerToken = {
        return SnapXEatsLoginHelper.shared.getLoginUserServerToken()
    }()
    
    var fbInstagramAccessToken = {
        return SnapXEatsLoginHelper.shared.getLoginUserFBInstagramAccessToken()
    }()
    
    var firstTimeUser = {
        return SnapXEatsLoginHelper.shared.firstTimeUser()
    }()
    
//    func reset() {
//        ratingPreference = nil
//        pricingPreference = nil
//        sortByPreference = nil
//        distancePreference = 0
//        isDirtyPreference = false
//        isLoggedIn = false
//        loginUserID = Snap
//    }
}

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
        selectedCuisine.removeAll()
    }
    
    static let shared = SelectedPreference()
    private init() {
    }
}
