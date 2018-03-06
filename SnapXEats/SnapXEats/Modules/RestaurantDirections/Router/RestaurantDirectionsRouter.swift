//
//  RestaurantDirectionsRouter.swift
//  SnapXEats
//
//  Created by synerzip on 28/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDirectionsRouter {

    // MARK: Properties

    weak var view: UIViewController?
    
    private init() {}
    static let shared = RestaurantDirectionsRouter()
    
    // MARK: Static methods

    func loadRestaurantDirectionsModule() -> RestaurantDirectionsViewController {
        let viewController = UIStoryboard.loadViewController() as RestaurantDirectionsViewController
        
        let presenter = RestaurantDirectionsPresenter()
        let router = RestaurantDirectionsRouter()
        let interactor = RestaurantDirectionsInteractor()

        viewController.presenter =  presenter
        
        presenter.view = viewController
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension RestaurantDirectionsRouter: RestaurantDirectionsWireframe {
    // TODO: Implement wireframe methods
}
