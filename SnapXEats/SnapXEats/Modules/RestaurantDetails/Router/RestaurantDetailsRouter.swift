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
    
    weak var view: RestaurantDetailsViewController?
    private var containerView: UIView?

    private init() {}
    static let shared = RestaurantDetailsRouter()

    func loadRestaurantDetailsModule() -> RestaurantDetailsViewController {
        let viewController = UIStoryboard.loadViewController() as RestaurantDetailsViewController
        
        let presenter = RestaurantDetailsPresenter.shared
        let router = RestaurantDetailsRouter.shared
        let interactor = RestaurantDetailsInteractor.shared

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

extension RestaurantDetailsRouter: RestaurantDetailsWireframe {
    func checkInternet() -> Bool {
        if let view = view  {
            return view.checkRechability()
        }
        return false
    }
}
