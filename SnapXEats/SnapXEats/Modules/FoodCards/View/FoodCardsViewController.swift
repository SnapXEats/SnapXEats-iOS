//
//  FoodCardsViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodCardsViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: FoodCardsPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FoodCardsViewController: FoodCardsView {
    // TODO: implement view output methods
}