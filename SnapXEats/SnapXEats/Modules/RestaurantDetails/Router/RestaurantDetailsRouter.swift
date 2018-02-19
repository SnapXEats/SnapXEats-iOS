//
//  RestaurantDetailsRouter.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import UIKit

class RestaurantDetailsRouter {

    // MARK: Properties
    
    weak var view: UIViewController?

    private init() {}
    static let singleInstance = RestaurantDetailsRouter()

    func loadRestaurantDetailsModule() -> RestaurantDetailsViewController {
        let viewController = UIStoryboard.loadViewController() as RestaurantDetailsViewController
        let presenter = RestaurantDetailsPresenter()
        let router = RestaurantDetailsRouter()
        let interactor = RestaurantDetailsInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension RestaurantDetailsRouter: RestaurantDetailsWireframe {
    // TODO: Implement wireframe methods
}
