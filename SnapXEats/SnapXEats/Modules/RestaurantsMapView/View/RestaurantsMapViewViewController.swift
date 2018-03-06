//
//  RestaurantsMapViewViewController.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantsMapViewViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: RestaurantsMapViewPresentation?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension RestaurantsMapViewViewController: RestaurantsMapViewView {
    func initView() {
        
    }
}
