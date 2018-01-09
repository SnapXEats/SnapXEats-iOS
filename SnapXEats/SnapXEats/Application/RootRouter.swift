
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

class RootRouter: NSObject {
    
    private override init() {}
    static var singleInstance = RootRouter()
    
    func presentFirstScreen(inWindow window: UIWindow) {
        presentLoginScreen()
    }
    
    func presentFirstScreen() {
        presentLoginScreen()
    }
    
    private func presentLoginScreen() {
        let loginViewController = LoginRouter.singletenInstance.loadLoginModule() as! LoginViewController
        presentView(loginViewController)
    }
    
    func presentLoginInstagramScreen(_ viewController: LoginView) {
        let instagramViewController = viewController as! InstagramViewController
         presentView(instagramViewController)
    }
    
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }    
}
