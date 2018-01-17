
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

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
    
    func presentFirstScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentLoginScreen() {
        let loginViewController = LoginRouter.singletenInstance.loadLoginModule() as! LoginViewController
        presentView(loginViewController)
    }
    
    func presentLoginInstagramScreen(_ viewController: LoginView) {
        let instagramViewController = viewController as! InstagramViewController
        window?.rootViewController?.present(instagramViewController, animated: true, completion: nil)
    }
    
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }    
}
