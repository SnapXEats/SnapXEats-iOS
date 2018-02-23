
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
    case firsTimeUser, login, instagram, location, firstScreen, foodcards(selectPreference: SelectedPreference, parentController: UINavigationController), selectLocation, dismissNewLocation, userPreference, foodAndCusinePreferences(preferenceType: PreferenceType, parentController: UINavigationController), restaurantDetails(restaurant: Restaurant, parentController: UINavigationController)
}

class RootRouter: NSObject {
    var window: UIWindow?
    var drawerController: KYDrawerController!
    
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
        let  instagramViewController = LoginRouter.singletenInstance.loadInstagramView() as! InstagramViewController
        window?.rootViewController?.present(instagramViewController, animated: true, completion: nil)
    }
    
    private func presentLocationScreen() {
        //let locatioViewController = LocationRouter.singleInstance.loadLocationModule() as! LocationViewController
        
        let locationNavigationController = LocationRouter.singleInstance.loadLocationModule()
        updateDrawerWithMainController(mainVC: locationNavigationController)
        presentView(drawerController)
    }
    
    private func pushFoodcardsScreen(selectedPreference: SelectedPreference, onNavigationController parentController: UINavigationController) {
        
        let foodCardVC = FoodCardsRouter.singleInstance.loadFoodCardModule()
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
    
    private func dissmissSelectLocationScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentSelectLocationScreen() {
        let selectLocationViewController = SelectLocationRouter.singleInstance.loadSelectLocationModule()
        window?.rootViewController?.present(selectLocationViewController, animated: true, completion: nil)
    }
    
    private func pushRestaurantDetailsScreen(onNavigationController parentController: UINavigationController, forRestaurant restaurant: Restaurant) {
        let restaurantDetailsVC = RestaurantDetailsRouter.shared.loadRestaurantDetailsModule()
        restaurantDetailsVC.restaurant = restaurant
        parentController.pushViewController(restaurantDetailsVC, animated: true)
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
        case .restaurantDetails(let restaurant, let parentController):
            pushRestaurantDetailsScreen(onNavigationController: parentController, forRestaurant: restaurant)
            
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
        let drawerVC = loadDrawerMenu()
        drawerController.mainViewController = mainVC
        drawerController.drawerViewController = drawerVC
    }
    
    func loadDrawerMenu() -> DrawerViewController {
        let storyboard = UIStoryboard(name: SnapXEatsStoryboard.foodCardsStoryboard, bundle: nil)
        let drawerVC = storyboard.instantiateViewController(withIdentifier: "drawerviewcontroller") as! DrawerViewController
        return drawerVC
    }
}
