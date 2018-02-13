
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
enum Screens {
    case login, instagram, location, firstScreen, foodcards(selectPreference: SelectedPreference, parentController: UINavigationController), selectLocation, dismissNewLocation, userPreference, foodAndCusinePreferences(preferenceType: PreferenceType, preferenceItems: [PreferenceItem], parentController: UINavigationController)
}

class RootRouter: NSObject {
    var window: UIWindow?
    var drawerController: KYDrawerController!
    
    private override init() {
        
    }
    static var singleInstance = RootRouter()

    func presentFirstScreen(inWindow window: UIWindow) {
       userLoggedIn()
    }
    
   private func userLoggedIn() {
        if faceBookLoggedIn() || instagramLoggedIn() {
            presentScreen(screens: .location)
        } else {
            guard let window  = UIApplication.shared.delegate?.window! else { return }
            self.window = window
            presentLoginScreen()
        }
    }
    
    private func instagramLoggedIn () -> Bool{
        return UserDefaults.standard.bool(forKey: InstagramConstant.INSTAGRAM_LOGGEDIN)
    }
    
   private func faceBookLoggedIn () -> Bool {
       if let _ =  AccessToken.current?.authenticationToken {
            return true
        }
        return false
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
    
    private func pushFoodAndCuisinePreferencesScreen(onNavigationController parentController: UINavigationController, withPreferenceType type: PreferenceType, withPreferenceItems items: [PreferenceItem]) {
        
        let foodCardVC = UserPreferenceRouter.singleInstance.loadCuisineAndFoodPreferenceModule()
        foodCardVC.preferenceType = type
        foodCardVC.preferenceItems = items
        parentController.pushViewController(foodCardVC, animated: true)
    }
    
    private func presentUserPreferencesScreen() {
        let userPreferenceNvController = UserPreferenceRouter.singleInstance.loadUserPreferenceModule()
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
    
    func presentScreen(screens: Screens) {
        switch screens {
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
        case .foodAndCusinePreferences(let preferenceType, let preferenceItems, let parentController):
            pushFoodAndCuisinePreferencesScreen(onNavigationController: parentController, withPreferenceType: preferenceType, withPreferenceItems: preferenceItems)
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
