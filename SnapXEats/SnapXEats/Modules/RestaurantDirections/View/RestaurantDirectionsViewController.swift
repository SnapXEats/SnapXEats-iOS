//
//  RestaurantDirectionsViewController.swift
//  SnapXEats
//
//  Created by synerzip on 28/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDirectionsViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: RestaurantDirectionsPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RestaurantDirectionsViewController: RestaurantDirectionsView {
    func initView() {
        
    }
}
