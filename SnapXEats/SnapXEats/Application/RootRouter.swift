
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
    case firsTimeUser, login, instagram(sharedLoginFromSkip: Bool, rootController: UINavigationController?), location, firstScreen, foodcards(selectPreference: SelectedPreference, parentController: UINavigationController), selectLocation(parent: UIViewController), userPreference, foodAndCusinePreferences(preferenceType: PreferenceType, parentController: UINavigationController), restaurantDetails(restaurantID: String, parentController: UINavigationController, showMoreInfo: Bool), restaurantDirections(details: RestaurantDetails, parentController: UINavigationController), wishlist, restaurantsMapView(restaurants: [Restaurant], parentController: UINavigationController), snapNShareHome(restaurantID: String), snapNSharePhoto(photo: UIImage, iparentController: UINavigationController, restaurantID: String), snapNShareSocialMedia(parentController: UINavigationController), checkin(restaurant: Restaurant),
    sharedSuccess(restaurantID: String), loginPopUp(restaurantID: String, parentController: UINavigationController), socialLoginFromLoginPopUp(parentController: UINavigationController), smartPhoto(dishID: String), smartPhotoDraft, foodJourney
}

class RootRouter: NSObject {
    private var window: UIWindow? {
        guard let window  = UIApplication.shared.delegate?.window! else { return nil }
        return window
    }
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
    
    private func presentLoginInstagramScreen(sharedLoginFromSkip: Bool, parentController: UINavigationController?) {
        let  instagramViewController = InstagramLoginRouter.shared.loadInstagramView() as! InstagramLoginViewController
        instagramViewController.sharedLoginFromSkip = sharedLoginFromSkip
        instagramViewController.parentController = parentController
        if sharedLoginFromSkip {
            window?.rootViewController?.dismiss(animated: false, completion: nil) // first dissmiss the  login  with FB and Instagram view when user try to shared photo 
        }
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
    
    private func presentSnapNShareHomeScreen(restaurantID: String) {
        let snapNShareHomeNavigation = SnapNShareHomeRouter.shared.loadSnapNShareHomeModule()
        if let snapNShareHomeVC = snapNShareHomeNavigation.viewControllers.first as? SnapNShareHomeViewController{
            snapNShareHomeVC.restaurantID = restaurantID
        }
        updateDrawerWithMainController(mainVC: snapNShareHomeNavigation)
        presentView(drawerController)
    }
    
    private func presentCheckinPopupForRestaurant(restaurant: Restaurant) {
        if let window = UIApplication.shared.keyWindow {
            let checkinPopup = CheckinPopupRouter.shared.loadCheckinPopupModule()
            checkinPopup.checkinPopupDelegate = self
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            checkinPopup.setupPopup(frame: popupFrame, restaurant: restaurant)
            window.addSubview(checkinPopup)
        }
    }
    
    private func dissmissSelectLocationScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentSelectLocationScreen(parent: UIViewController) {
        let selectLocationViewController = SelectLocationRouter.singleInstance.loadSelectLocationModule()
        parent.present(selectLocationViewController, animated: true, completion: nil)
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
    
    private func pushSnapNSharePhotoScreen(onNavigationController parentController: UINavigationController, withPhoto photo: UIImage, restaurantID: String) {
        let snapNSharePhotoVC = SnapNSharePhotoRouter.shared.loadSnapNSharePhotoModule()
        snapNSharePhotoVC.snapPhoto = photo
        snapNSharePhotoVC.restaurntID = restaurantID
        parentController.pushViewController(snapNSharePhotoVC, animated: true)
    }
    
    private func pushSnapNShareSocialMediaScreen(onNavigationController parentController: UINavigationController) {
        let snapNShareSocialMediaVC = SnapNShareSocialMediaRouter.shared.loadSnapNshareSocialMediaModule()
        parentController.pushViewController(snapNShareSocialMediaVC, animated: true)
    }
    
    private func presentSocialShareAferNewLogin(parentController: UINavigationController) {
        let drawerVC = DrawerRouter.shared.loadDrawerMenu()
        drawerController.drawerViewController = drawerVC
        window?.rootViewController?.dismiss(animated: true, completion: nil)
        pushSnapNShareSocialMediaScreen(onNavigationController: parentController)
    }
    
    private func presentLoginPopUp(restaurantID: String, parentController: UINavigationController) {
        let viewController = LoginPopUpRouter.shared.loadLoginPopUpView()
        viewController.restaurantID = restaurantID
        viewController.rootController = parentController
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func updateDrawerState(state: KYDrawerController.DrawerState) {
        drawerController.setDrawerState(state, animated: true)
    }
    
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState) {
        drawerController.setDrawerState(drawerState, animated: true)
        presentScreen(screens: screen)
    }
    
    func presentSmartPhotoScreen(dishID: String) {
            let smartPhotoController = SmartPhotoRouter.shared.loadModule()
            smartPhotoController.dishID = dishID
            window?.rootViewController?.present(smartPhotoController, animated: true, completion: nil)
    }
    
    func presentSmartPhotoDraft() {
        let smartPhotoDraftVC = SmartPhotoDraftRouter.shared.loadSmartPhotoDraftModule()
        updateDrawerWithMainController(mainVC: smartPhotoDraftVC)
        presentView(drawerController)
    }
    
    func presentFoodJourney() {
        let foodJourney = FoodJourneyRouter.shared.loadFoodJoureyModule()
        updateDrawerWithMainController(mainVC: foodJourney)
        presentView(drawerController)
    }
    
    func presentScreen(screens: Screens) {
        
        if window?.rootViewController == nil &&  drawerController != nil {
            presentView(drawerController)  // some tim the rootViewController become nil
        }
        
        switch screens {
        case .firsTimeUser:
            presentFirstTimeUserScreen()
        case .firstScreen:
            presentFirstScreen()
        case .login:
            presentLoginScreen()
        case .instagram(let sharedLoginFromSkip, let parentController):
            presentLoginInstagramScreen(sharedLoginFromSkip: sharedLoginFromSkip, parentController: parentController)
        case .location:
            presentLocationScreen()
        case .foodcards(let selectedPreference, let parentController):
            pushFoodcardsScreen(selectedPreference: selectedPreference, onNavigationController: parentController)
        case .selectLocation(let  viewController):
            presentSelectLocationScreen(parent: viewController)
        case .userPreference:
            presentUserPreferencesScreen()
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
        case .snapNShareHome(let restaurantid):
            presentSnapNShareHomeScreen(restaurantID: restaurantid)
        case .checkin(let restaurant):
            presentCheckinPopupForRestaurant(restaurant: restaurant)
        case .snapNSharePhoto(let photo, let parentController, let reataurantID):
            pushSnapNSharePhotoScreen(onNavigationController: parentController, withPhoto: photo, restaurantID: reataurantID)
        case .snapNShareSocialMedia(let parentController):
            pushSnapNShareSocialMediaScreen(onNavigationController: parentController)
        case .sharedSuccess(let restaurantID):
            presentSuccessFulSharedPhoto(restaurantID: restaurantID)
        case .loginPopUp(let restaurantID, let parentController):
            presentLoginPopUp(restaurantID: restaurantID, parentController: parentController)
        case .socialLoginFromLoginPopUp(let parentController):
            presentSocialShareAferNewLogin( parentController: parentController)
        case .smartPhoto(let dishID):
            presentSmartPhotoScreen(dishID: dishID)
        case .smartPhotoDraft:
            presentSmartPhotoDraft()
        case .foodJourney:
            presentFoodJourney()
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
    func userDidChekintoRestaurant(restaurantID: String) {
        //SnapXEatsLoginHelper.shared.checkinUser()
        presentScreen(screen: .snapNShareHome(restaurantID: restaurantID), drawerState: .closed)
    }
}

extension RootRouter: SharedSucceesActionsDelegate {
    func movetoSnapNShareScreen(restaurantID: String) {
        presentScreen(screen: .snapNShareHome(restaurantID: restaurantID), drawerState: .closed)
    }
    
    func popupDidDismiss() {
        presentScreen(screens: .location)
    }
    
    
    private func presentSuccessFulSharedPhoto(restaurantID: String) {
        if let window = UIApplication.shared.keyWindow {
            let sharedSucceesPopup = SnapNShareSocialMediaRouter.shared.loadSharedSuccessPopup()
            sharedSucceesPopup.restaurantID = restaurantID
            sharedSucceesPopup.sharedSuccessDelegate = self
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            sharedSucceesPopup.setupPopup(popupFrame, rewardPoints: 0)
            window.addSubview(sharedSucceesPopup)
        }
    }
    
}
