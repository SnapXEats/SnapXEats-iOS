//
//  SelectedPreference.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 30/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum RatingPreferences: Int {
    case defaultStart = 0
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
    
    func displayText() -> String {
        switch self {
        case .auto:
            return "$"
        case .single:
            return "$$"
        case .double:
            return "$$$"
        case .tripple:
            return "$$$$"
        case .quadraple:
            return "$$$$$"
        }
    }
}

enum SortByPreference: Int {
    case distance = 0
    case rating = 1
}

class UserDishReview {
    var restaurantInfoId : String?
    var smartPhoto_Draft_Stored_id: String?
    // This should be used to check if there is any Restaurant available for Checkin automatically. Will be set when user goes to Direction Page for particular restaurant and then start Tracking current location.
    var restaurant: Restaurant?
    
    private init() {}
    static let shared = UserDishReview()
    
    func resetData() {
        restaurantInfoId = nil
        smartPhoto_Draft_Stored_id = nil
        restaurant = nil
    }
    
}

class LoginUserPreferences {
    
    static let shared = LoginUserPreferences()
    private init() {}
    var ratingPreference: RatingPreferences = .defaultStart
    var pricingPreference: PricingPreference = .auto
    var sortByPreference: SortByPreference = .distance
    var distancePreference = PreferecneConstant.defaultDistancePreference
    
    var foodPreference = [FoodItem]()
    var cuisinePreference = [CuisineItem]()
    
    var isDirtyFoodPreference = false
    var isDirtyCuisinePreference = false
    var isDirtyPreference = false
    
    var userDishReview =  UserDishReview.shared
    
    var isDirty: Bool {
        get {
            return isDirtyCuisinePreference || isDirtyFoodPreference || isDirtyPreference
        }
        set {
            isDirtyCuisinePreference = newValue
            isDirtyFoodPreference = newValue
            isDirtyPreference = newValue
        }
    }
    
    var isFBlogin: Bool {
        return SnapXEatsLoginHelper.shared.isLoggedUsingFB()
    }
    
    var isInstagramlogin: Bool {
        return SnapXEatsLoginHelper.shared.isLoggedUsingInstagram()
    }
    
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
    
    var fbSharingenabled: Bool {
        return  SocialPlatformHelper.shared.fbSharingEnabled()
    }
    
    func reset() {
        ratingPreference = .defaultStart
        pricingPreference = .auto
        sortByPreference = .distance
        distancePreference = PreferecneConstant.defaultDistancePreference
        isDirty = false
        foodPreference.removeAll()
        cuisinePreference.removeAll()
        userDishReview.resetData()
    }
}

class SelectedPreference {
    var location = SnapXEatsLocation ()
    var selectedCuisine = [String]()
    var loginUserPreference = LoginUserPreferences.shared
    func getLatitude() -> (Decimal, Decimal) {
        let lat  =  location.latitude // 40.7179//40.4862157
        let long =  location.longitude // -73.9901//-74.4518188
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
