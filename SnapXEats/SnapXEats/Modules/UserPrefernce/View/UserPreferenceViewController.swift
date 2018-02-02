//
//  UserPreferenceViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class UserPreferenceViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: UserPreferencePresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UserPreferenceViewController: UserPreferenceView {
    func initView() {
        
    }
    
    // TODO: implement view output methods
}
