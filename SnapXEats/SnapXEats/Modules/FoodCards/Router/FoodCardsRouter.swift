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
    
     func loadFoodCardModule() -> UINavigationController {
        
        let foodCardNavigationController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.foodCardsStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.foodCardsNavigationControllerID)
        
        guard let firstViewController = foodCardNavigationController.viewControllers.first, let viewController = firstViewController as? FoodCardsViewController else {
            return UINavigationController()
        }
        
        let presenter = FoodCardsPresenter.singleInstance
        let router = FoodCardsRouter.singleInstance
        let interactor = FoodCardsInteractor.singleInstance

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return foodCardNavigationController
    }
    
    func loadDrawerMenu() -> DrawerViewController {
        let storyboard = UIStoryboard(name: "FoodCards", bundle: nil)
        let drawerVC = storyboard.instantiateViewController(withIdentifier: "drawerviewcontroller") as! DrawerViewController
        return drawerVC
    }
}

extension FoodCardsRouter: FoodCardsWireframe {
}
