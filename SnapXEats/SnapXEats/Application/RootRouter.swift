
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
enum Screens {
    case login, instagram, location, firstScreen, foodcards, selectLocation, dismissNewLocation
}

protocol RootWireFrame {
    func presentScreen(screen: Screens)
}
class RootRouter: NSObject {
    var window: UIWindow?
    
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
    
    func instagramLoggedIn () -> Bool{
        return UserDefaults.standard.bool(forKey: InstagramConstant.INSTAGRAM_LOGGEDIN)
    }
    
    func faceBookLoggedIn () -> Bool {
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
    
    func presentFoodcardsScreen() {
        // This is temp code
        let locatioViewController = FoodCardsRouter.singleInstance.loadFoodCardModule() as! FoodCardsViewController
        presentView(locatioViewController)
    }
    
    func dissmissSelectLocationScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func presentSelectLocationScreen() {
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
        case .foodcards:
            presentFoodcardsScreen()
        case .selectLocation:
            presentSelectLocationScreen()
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
