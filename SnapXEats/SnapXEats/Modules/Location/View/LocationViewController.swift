//
//  LocationViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LocationViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: LocationPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LocationViewController: LocationView {
    // TODO: implement view output methods
}
