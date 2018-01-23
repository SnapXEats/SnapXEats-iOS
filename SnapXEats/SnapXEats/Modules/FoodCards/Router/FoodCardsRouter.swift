//
//  FoodCardsRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodCardsRouter {

    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Static methods

    static func setupModule() -> FoodCardsViewController {
        let viewController = UIStoryboard.loadViewController() as FoodCardsViewController
        let presenter = FoodCardsPresenter()
        let router = FoodCardsRouter()
        let interactor = FoodCardsInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension FoodCardsRouter: FoodCardsWireframe {
    // TODO: Implement wireframe methods
}
