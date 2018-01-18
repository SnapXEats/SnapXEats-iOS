//
//  LocationRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LocationRouter {

    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Static methods

    static func setupModule() -> LocationViewController {
        let viewController = UIStoryboard.loadViewController() as LocationViewController
        let presenter = LocationPresenter()
        let router = LocationRouter()
        let interactor = LocationInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension LocationRouter: LocationWireframe {
    // TODO: Implement wireframe methods
}
