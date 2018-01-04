
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

class RootRouter: NSObject {
    
    func presentFirstScreen(inWindow window: UIWindow) {
        presentMainSearchScreen()
    }
    
    private func presentMainSearchScreen() {
        let mainSearchViewController = LoginRouter.setupModule()
        presentView(mainSearchViewController)
    }
    
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }    
}
