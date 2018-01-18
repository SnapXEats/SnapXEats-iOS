
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
enum Screens {
    case login, instagram, location, firstScreen
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
        guard let window  = UIApplication.shared.delegate?.window! else { return }
        self.window = window
        presentLoginScreen()
    }
    
    private func presentFirstScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentLocationScreen() {
        let locatioViewController = LocationRouter.singleInstance.loadLocationModule() as! LocationViewController
        presentView(locatioViewController)
    }
    
    private func presentLoginScreen() {
        let loginViewController = LoginRouter.singletenInstance.loadLoginModule() as! LoginViewController
        presentView(loginViewController)
    }
    
    private func presentLoginInstagramScreen() {
        let  instagramViewController = LoginRouter.singletenInstance.loadInstagramView() as! InstagramViewController
        window?.rootViewController?.present(instagramViewController, animated: true, completion: nil)
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
        }
    }
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }    
}
