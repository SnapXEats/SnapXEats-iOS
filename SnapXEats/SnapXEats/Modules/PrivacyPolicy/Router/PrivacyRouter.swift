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
    
    func loadPrivacyPolicyModule() -> PrivacyPolicyViewController {
       return UIStoryboard.loadViewController() as PrivacyPolicyViewController
    }
}
