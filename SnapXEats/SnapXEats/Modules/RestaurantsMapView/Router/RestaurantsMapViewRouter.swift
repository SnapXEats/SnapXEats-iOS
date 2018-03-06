//
//  RestaurantsMapViewRouter.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantsMapViewRouter {

    // MARK: Properties

    weak var view: UIViewController?
    private init() {}
    static let shared = RestaurantsMapViewRouter()
    
    // MARK: Static methods

    func loadRestaurantsMapViewModule() -> RestaurantsMapViewViewController {
        let viewController = UIStoryboard.loadViewController() as RestaurantsMapViewViewController
        let presenter = RestaurantsMapViewPresenter()
        let router = RestaurantsMapViewRouter()
        let interactor = RestaurantsMapViewInteractor()

        viewController.presenter =  presenter
        presenter.baseView = viewController
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension RestaurantsMapViewRouter: RestaurantsMapViewWireframe {
    // TODO: Implement wireframe methods
}
