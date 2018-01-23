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
    private init() {}
    // MARK: Static methods
    static let singleInstance = FoodCardsRouter()
     func loadFoodCardModule() -> FoodCardsViewController {
        let viewController = UIStoryboard.loadViewController() as FoodCardsViewController
        let presenter = FoodCardsPresenter.singleInstance
        let router = FoodCardsRouter.singleInstance
        let interactor = FoodCardsInteractor.singleInstance

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
    func presentScreen(screen: Screens) {
        // Todo implement this method
    }
}
