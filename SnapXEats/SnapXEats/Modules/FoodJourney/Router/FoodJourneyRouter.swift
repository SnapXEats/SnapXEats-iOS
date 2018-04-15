//
//  FoodJourneyRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodJourneyRouter {

    // MARK: Properties

    weak var view: UIViewController?
    
    private init() {}
    static let shared = FoodJourneyRouter()
    // MARK: Static methods

     func loadFoodJoureyModule() -> UINavigationController {
        let foodJourneyNC = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.foodJourney, storyBoardId: SnapXEatsStoryboardIdentifier.foodCardsNavigationControllerID)
        
        guard let firstViewController = foodJourneyNC.viewControllers.first, let viewController = firstViewController as? FoodJourneyViewController else {
            return UINavigationController()
        }
        let presenter = FoodJourneyPresenter.shared
        let router = FoodJourneyRouter.shared
        let interactor = FoodJourneyInteractor.shared

        viewController.presenter =  presenter

        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return foodJourneyNC
    }
}

extension FoodJourneyRouter: FoodJourneyWireframe {
    // TODO: Implement wireframe methods
}
