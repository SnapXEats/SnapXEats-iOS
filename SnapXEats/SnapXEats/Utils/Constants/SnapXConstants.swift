//
//  SnapXEnum.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum InstagramConstant {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "739cbd7da5c048fbab575487859602c9"
    static let INSTAGRAM_CLIENTSERCRET = "9df371b962c945e69c2e3f5603ab1a32"
    static let INSTAGRAM_REDIRECT_URI = "http://www.snapxeats.com"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
    static let INSTAGRAM_AUTH_STRING = "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True"
    static let INSTAGRAM_LOGGEDIN = "instagramLoggedIn"
    case instagramURL
    
    private func getString() -> String {
        return  String(format: InstagramConstant.INSTAGRAM_AUTH_STRING, arguments: [InstagramConstant.INSTAGRAM_AUTHURL,InstagramConstant.INSTAGRAM_CLIENT_ID,InstagramConstant.INSTAGRAM_REDIRECT_URI, InstagramConstant.INSTAGRAM_SCOPE])
    }
    
    func getRequest() -> URLRequest {
        let string = getString()
        return URLRequest.init(url: URL.init(string: string)!)
    }
}

enum SnapXEatsBuild {
    case buildVersion
    
    func getBuildVersion() -> String {
        var buildVersion = ""
        if let showBuildVersion = Bundle.main.infoDictionary!["BuildVersion"] as? Bool, showBuildVersion == true {
            let appBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            buildVersion = "V-\(appVersion)-Build-\(appBuildNumber)"
        }
        return buildVersion
    }
}

enum SnapXEatsStoryboard {
    static let loginStoryboard = "Login"
    static let locationStoryboard = "Location"
    static let foodCardsStoryboard = "FoodCards"
    static let userPreferenceStoryboard = "UserPreference"
}

enum SnapXEatsStoryboardIdentifier {
    static let loginViewControllerID = "LoginViewController"
    static let instagramViewControllerID = "InstagramViewController"
    static let locationViewControllerID = "LocationViewController"
    static let locationNavigationControllerID = "LocationNavigationController"
    static let foodCardsNavigationControllerID = "FoodCardsNavigationController"
    static let locationCellReuseIdentifier = "CuisineCell"
    static let locationCuisineCollectionCellIdentifier = "CuisineCollectionViewCell"
    static let userPreferenceNavigationControllerID = "UserPreferenceNavigationController"
    static let cusineAndFoodPreferencesViewControllerID = "CusineAndFoodPreferencesViewControllerID"
    static let restaurantTimingsViewController = "RestaurantTimingsViewController"
    static let drawerViewController = "DrawerViewController"
}

enum SnapXEatsLocationConstant {
    static let locationAlertTitle = "Location not Detected"
    static let locationAlertMessage = "Location services are turned off on your device. Please go to settings and enable location services to use this feature or manually select a location."
}
enum SnapXEatsWebServicePath {
    static let  port = "3000"
    static let  rootURL = "http://ec2-18-216-193-78.us-east-2.compute.amazonaws.com:" + port
    static let  cuisinePreferenceURL = "/api/v1/cuisine"
    static let  dishesURL = "/api/v1/dishes"
    static let  foodtypesURL = "/api/v1/foodTypes"
    static let  cuisinetypesURL = "/api/v1/cuisine"
    static let  snapXEatsUser = "/api/v1/users"
    static let  restaurantDetails = "/api/v1/restaurant"
    static let  userPreferene = "/api/v1/userPreferences"
}

enum SnapXEatsImageNames {
    static let navigationLogo = "snapx_logo_orange"
    static let navigationMenu = "navigation_menu_icon"
    static let navigationSearch = "navigation_search_icon"
    static let placeholder_cuisine = "placeholder_cuisine"
    static let profile_placeholder = "profile_placeholder"
    static let likeitOverlay = "likeit"
    static let notnowOverlay = "notnow"
    static let trylaterOverlay = "trylater"
}


enum SnapXEatsPlaceSearchConstants {
    static let autocompleteApiUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let apiKey = "AIzaSyBhb0GdrMqn4ge5QLgxkybQv66M6_bu7y0"
    static let components = "country:in"
    static let detailsApiUrl = "https://maps.googleapis.com/maps/api/place/details/json"
}

enum SnapXEatsPlaceSearchRequestKeys {
    static let input = "input"
    static let components = "components"
    static let key = "key"
    static let placeid = "placeid"
}


enum SnapXEatsPageTitles {
    static let restaurants = "Restaurants"
    static let wishlist = "Wishlist"
    static let preferences = "Preferences"
    static let foodJourney = "Food Journeys"
    static let rewards = "Rewards"
    static let cusinePreferences = "Cuisine Preferences"
    static let foodPreferences = "Food Preferences"
    static let restaurantDetail = "Restaurant Info"
}

enum SnapXEatsCellResourceIdentifiler {
    static let navigationMenu = "navigationtionmenucell"
    static let preferenceType = "PreferenceTypeCell"
    static let restaurantSpeciality = "RestaurantSpecialityCell"
    static let restaurantTiming = "restaurantTimingCell"
}

enum SnapXEatsNibNames {
    static let navigationMenuTableViewCell = "NavigationMenuTableViewCell"
    static let preferenceTypeCollectionViewCell = "PreferenceTypeCollectionViewCell"
    static let restaurantSpecialityCollectionViewCell = "RestaurantSpecialityCollectionViewCell"
    static let foodCardOverlayView = "foodCardOverlayView"
    static let foodCardView = "FoodCardView"
}

enum SnapXEatsWebServiceParameterKeys {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let cuisineArray = "cuisineArray"
    static let authorization = "Authorization"
    static let BearerString = "Bearer "
}
enum SnapXButtonTitle {
    static let ok = "Ok"
    static let cancel = "Cancel"
    static let settings = "Settings"
    static let save = "Save"
    static let discard = "Discard"
    static let yes = "YES"
    static let notnow = "Not Now"
}

enum SnapXEatsAppDefaults {
    static let emptyString = ""
}

enum SnapXEatsSettingsURL {
    static let appLocationSettings = UIApplicationOpenSettingsURLString
    static let deviceLocationSetting = "App-Prefs:root=Privacy&path=LOCATION" // There is a bug in ios 11 because of that it is not oppening the URL
}

enum SnapXEatsConstant {
    static let onceDeniedLocation = "SnapXEatsOnceDenedLocation"
    static let emptyString = ""
    static let fbLoginToken = "SnapXEatsFBLoginToken"
    static let loginID = "SnapXEatsLoginId"
    static let fbLoginExpireDate = "SnapXEatsFBLoginExpireDate"
    static let snapXLoginData = "SnapXLoginData"
    static let userLoginToken = "access_token"
    static let social_platform = "social_platform"
    static let social_id = "social_id"
    static let platFormFB = "facebook"
    static let platFormInstagram = "instagram"
    static let snaXEatsFirstTimeUser = "SnaXEatsFirstTimeUser"
    static let firstTimeUser = "firstTimeUser"
}

enum UberAppConstants {
    static let appstoreURL = "itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8"
    static let urlscheme = "uber://"
}

enum SnapXEatsDirectionConstants {
    static let pingExamValidatedString = "Congratulations! Your exam has been validated. You have %@ to start this exam.\n\n"
    static let directionApiUrl = "https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=%@&origin=%@&destination=%@"
    static let apiKey = "AIzaSyA0wc__o_uvrQwR-Z_L-DzD3OlwPMmyG34"
    static let durationTextPrefix = " Away"
}

enum AlertMessage {
    static var messageNoInternet = "SnapXEats required internet connection to process your request. Please enable your internet access."
    static var messageSuccess = "Request Succesful"
    static var loginError = "Server Error during process your request"
    static var cancelRequest = "User canceled request"
    static var logOutMessage = "Do you really want to Logout of SnapXEats"
    static let preferenceMessage = "You have made some changes to your preferences, would you like save them."
    static let uberRedirectConfirmation = "Are you sure you want to book an Uber ride?"
    static let uberInstallConfirmation = "You need to install the uber app from app store to book a ride. Do you want to install it now?"
}

enum AlertTitle {
    static let loginTitle = "Error"
    static let preferenceTitle = "Preference Error"
    static var logOutTitle = "LogOut"
}

enum PreferecneConstant {
    static let restaurant_rating = "restaurant_rating"
    static let restaurant_price  = "restaurant_price"
    static let restaurant_distance = "restaurant_distance"
    static let sort_by_rating = "sort_by_rating"
    static let sort_by_distance = "sort_by_distance"
    static let user_food_preferences = "user_food_preferences"
    static let food_type_info_id = "food_type_info_id"
    static let is_food_like = "is_food_like"
    static let is_food_favourite = "is_food_favourite"
    
    static let user_cuisine_preferences = "user_cuisine_preferences"
    static let cuisine_info_id = "cuisine_info_id"
    static let is_cuisine_like = "is_cuisine_like"
    static let is_cuisine_favourite = "is_cuisine_favourite"
}

