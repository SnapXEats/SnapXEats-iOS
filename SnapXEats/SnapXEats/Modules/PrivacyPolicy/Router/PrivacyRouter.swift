//
//  Router.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 21/06/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class PrivacyRouter {
    
    // MARK: Properties
    
    weak var view: UIViewController?
    
    private init() {}
    static let shared = PrivacyRouter()
    // MARK: Static methods
    
    func loadPrivacyPolicyModule() -> UINavigationController {
        let privacyPolicyNC = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.privacyPolicy, storyBoardId: SnapXEatsStoryboardIdentifier.privacyPolicyNavigationController)
        
        guard let firstViewController = privacyPolicyNC.viewControllers.first, let _ = firstViewController as? PrivacyPolicyViewController else {
            return UINavigationController()
        }
       return privacyPolicyNC
    }
}
