
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
enum Screens {
    case login, instagram, location, firstScreen, foodcards(selectPreference: SelectedPreference?), selectLocation, dismissNewLocation, userPreference
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
        let locatioViewController = LocationRouter.singleInstance.loadLocationModule() as! LocationViewController
        presentView(locatioViewController)
    }
    
    private func presentFoodcardsScreen(selectedPreference: SelectedPreference) {
        // Embed the VC into the Drawer
        
        let foodCardNavigationController = FoodCardsRouter.singleInstance.loadFoodCardModule()
        if let firstViewController = foodCardNavigationController.viewControllers.first, let foodCardViewController = firstViewController as? FoodCardsViewController {
            drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: (0.61 * UIScreen.main.bounds.width))
            let drawerVC = FoodCardsRouter.singleInstance.loadDrawerMenu()
            foodCardViewController.selectedPrefernce = selectedPreference
            drawerController.mainViewController = foodCardNavigationController
            drawerController.drawerViewController = drawerVC
            presentView(drawerController)
        }

    }
    
    private func presentUserPreferencesScreen() {
        let userPreferenceNvController = UserPreferenceRouter.singleInstance.loadUserPreferenceModule()
        drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: (0.61 * UIScreen.main.bounds.width))
            
        let drawerVC = FoodCardsRouter.singleInstance.loadDrawerMenu()
        drawerController.mainViewController = userPreferenceNvController
        drawerController.drawerViewController = drawerVC
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
        case .foodcards(let selectedPreference):
            presentFoodcardsScreen(selectedPreference: selectedPreference)
        case .selectLocation:
            presentSelectLocationScreen()
        case .userPreference:
            presentUserPreferencesScreen()
        case .dismissNewLocation:
            dissmissSelectLocationScreen()
        }
    }
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }
}
