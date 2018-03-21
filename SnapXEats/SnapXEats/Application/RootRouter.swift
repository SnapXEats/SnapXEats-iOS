
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftInstagram

enum Screens {
    case firsTimeUser, login, instagram, location, firstScreen, foodcards(selectPreference: SelectedPreference, parentController: UINavigationController), selectLocation, dismissNewLocation, userPreference, foodAndCusinePreferences(preferenceType: PreferenceType, parentController: UINavigationController), restaurantDetails(restaurantID: String, parentController: UINavigationController, showMoreInfo: Bool), restaurantDirections(details: RestaurantDetails, parentController: UINavigationController), wishlist, restaurantsMapView(restaurants: [Restaurant], parentController: UINavigationController), snapNShareHome, snapNSharePhoto(photo: UIImage, iparentController: UINavigationController), snapNShareSocialMedia(parentController: UINavigationController), checkin
}

class RootRouter: NSObject {
    private var window: UIWindow?
    private var drawerController: KYDrawerController!
    private override init() {
        
    }
    static var shared = RootRouter()
    
    func presentFirstScreen(inWindow window: UIWindow) {
        userLoggedIn()
    }
    
    private func presentFirstTimeUserScreen() {
          showFirstScreen()
    }
    private func userLoggedIn() {
        if faceBookLoggedIn() || instagramLoggedIn() {
            showFirstScreen()
        } else {
            guard let window  = UIApplication.shared.delegate?.window! else { return }
            self.window = window
            presentLoginScreen()
        }
    }
    
    private func showFirstScreen() {
        SnapXEatsLoginHelper.shared.firstTimeUser()
            ? presentScreen(screens: .userPreference)
            : presentScreen(screens: .location)
    }
    
    private func instagramLoggedIn () -> Bool{
        return UserDefaults.standard.bool(forKey: InstagramConstant.INSTAGRAM_LOGGEDIN)
    }
    
    private func faceBookLoggedIn () -> Bool {
        return SnapXEatsLoginHelper.shared.fbHelper()
    }
    
    private func presentFirstScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentLoginScreen() {
        let loginViewController = LoginRouter.singletenInstance.loadLoginModule() as! LoginViewController
        presentView(loginViewController)
    }
    
    private func presentLoginInstagramScreen() {
        let  instagramViewController = InstagramLoginRouter.shared.loadInstagramView() as! InstagramLoginViewController
        window?.rootViewController?.present(instagramViewController, animated: true, completion: nil)
    }
    
    private func presentLocationScreen() {
        //let locatioViewController = LocationRouter.singleInstance.loadLocationModule() as! LocationViewController
        
        let locationNavigationController = LocationRouter.singleInstance.loadLocationModule()
        updateDrawerWithMainController(mainVC: locationNavigationController)
        presentView(drawerController)
    }
    
    private func pushFoodcardsScreen(selectedPreference: SelectedPreference, onNavigationController parentController: UINavigationController) {
        
        let foodCardVC = FoodCardsRouter.shared.loadFoodCardModule()
        foodCardVC.selectedPrefernce = selectedPreference
        parentController.pushViewController(foodCardVC, animated: true)
    }
    
    private func pushFoodAndCuisinePreferencesScreen(onNavigationController parentController: UINavigationController, withPreferenceType type: PreferenceType) {
        
        let foodCardVC = FoodAndCuisinePreferenceRouter.shared.loadFoodAndCuisinePreferenceModule()
        foodCardVC.preferenceType = type
        parentController.pushViewController(foodCardVC, animated: true)
    }
    
    private func presentUserPreferencesScreen() {
        let userPreferenceNvController = UserPreferenceRouter.shared.loadUserPreferenceModule()
        updateDrawerWithMainController(mainVC: userPreferenceNvController)
        presentView(drawerController)
    }
    
    private func presentWishlistScreen() {
        let wishlistNvController = WishlistRouter.shared.loadWishlistModule()
        updateDrawerWithMainController(mainVC: wishlistNvController)
        presentView(drawerController)
    }
    
    private func pushRestaurantsMapView(onNavigationController parentController: UINavigationController, withRestaurants restaurants: [Restaurant]) {
        let restaurantMapsVC = RestaurantsMapViewRouter.shared.loadRestaurantsMapViewModule()
        restaurantMapsVC.restaurants = restaurants
        parentController.pushViewController(restaurantMapsVC, animated: true)
    }
    
    private func presentSnapNShareHomeScreen() {
        let snapNShareHomeVC = SnapNShareHomeRouter.shared.loadSnapNShareHomeModule()
        updateDrawerWithMainController(mainVC: snapNShareHomeVC)
        presentView(drawerController)
    }
    
    private func presentCheckinPopup() {
        if let window = UIApplication.shared.keyWindow {
            let checkinPopup = UINib(nibName:SnapXEatsNibNames.checkinPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CheckinPopup
            checkinPopup.checkinPopupDelegate = self
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            checkinPopup.setupPopup(frame: popupFrame)
            window.addSubview(checkinPopup)
        }
    }
    
    private func dissmissSelectLocationScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentSelectLocationScreen() {
        let selectLocationViewController = SelectLocationRouter.singleInstance.loadSelectLocationModule()
        window?.rootViewController?.present(selectLocationViewController, animated: true, completion: nil)
    }
    
    private func pushRestaurantDetailsScreen(onNavigationController parentController: UINavigationController, forRestaurant restaurantID: String, showMoreInfo: Bool) {
        let restaurantDetailsVC = RestaurantDetailsRouter.shared.loadRestaurantDetailsModule()
        restaurantDetailsVC.restaurant_info_id = restaurantID
        restaurantDetailsVC.showMoreInfo = showMoreInfo
        parentController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    private func pushRestaurantDirectionsScreen(onNavigationController parentController: UINavigationController, withDetails details: RestaurantDetails) {
        let restaurantDetailsVC = RestaurantDirectionsRouter.shared.loadRestaurantDirectionsModule()
        restaurantDetailsVC.restaurantDetails = details
        parentController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    private func pushSnapNSharePhotoScreen(onNavigationController parentController: UINavigationController, withPhoto photo: UIImage) {
        let snapNSharePhotoVC = SnapNSharePhotoRouter.shared.loadSnapNSharePhotoModule()
        snapNSharePhotoVC.snapPhoto = photo
        parentController.pushViewController(snapNSharePhotoVC, animated: true)
    }
    
    private func pushSnapNShareSocialMediaScreen(onNavigationController parentController: UINavigationController) {
        let snapNShareSocialMediaVC = SnapNShareSocialMediaRouter.shared.loadSnapNshareSocialMediaModule()
        parentController.pushViewController(snapNShareSocialMediaVC, animated: true)
    }
    
    func updateDrawerState(state: KYDrawerController.DrawerState) {
         drawerController.setDrawerState(state, animated: true)
    }
    
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState) {
        drawerController.setDrawerState(drawerState, animated: true)
        presentScreen(screens: screen)
    }
    func presentScreen(screens: Screens) {
        switch screens {
        case .firsTimeUser:
            presentFirstTimeUserScreen()
        case .firstScreen:
            presentFirstScreen()
        case .login:
            presentLoginScreen()
        case .instagram:
            presentLoginInstagramScreen()
        case .location:
            presentLocationScreen()
        case .foodcards(let selectedPreference, let parentController):
            pushFoodcardsScreen(selectedPreference: selectedPreference, onNavigationController: parentController)
        case .selectLocation:
            presentSelectLocationScreen()
        case .userPreference:
            presentUserPreferencesScreen()
        case .dismissNewLocation:
            dissmissSelectLocationScreen()
        case .foodAndCusinePreferences(let preferenceType, let parentController):
            pushFoodAndCuisinePreferencesScreen(onNavigationController: parentController, withPreferenceType: preferenceType)
        case .restaurantDetails(let restaurantID, let parentController, let showMoreInfo):
            pushRestaurantDetailsScreen(onNavigationController: parentController, forRestaurant: restaurantID, showMoreInfo: showMoreInfo)
        case .restaurantDirections(let details, let parentController):
            pushRestaurantDirectionsScreen(onNavigationController: parentController, withDetails: details)
        case .wishlist:
            presentWishlistScreen()
        case .restaurantsMapView(let restaurants, let parentController):
            pushRestaurantsMapView(onNavigationController: parentController, withRestaurants: restaurants)
        case .snapNShareHome:
            presentSnapNShareHomeScreen()
        case .checkin:
            presentCheckinPopup()
        case .snapNSharePhoto(let photo, let parentController):
            pushSnapNSharePhotoScreen(onNavigationController: parentController, withPhoto: photo)
        case .snapNShareSocialMedia(let parentController):
            pushSnapNShareSocialMediaScreen(onNavigationController: parentController)
        }
    }
    
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }
    
    private func updateDrawerWithMainController(mainVC: UINavigationController) {
        drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: (0.61 * UIScreen.main.bounds.width))
        let drawerVC = DrawerRouter.shared.loadDrawerMenu()
        drawerController.mainViewController = mainVC
        drawerController.drawerViewController = drawerVC
    }
}

extension RootRouter: CheckinPopUpActionsDelegate {
    func userDidChekin(_ popup: CheckinPopup) {
        SnapXEatsLoginHelper.shared.checkinUser()
        presentScreen(screen: .snapNShareHome, drawerState: .closed)
    }
}
