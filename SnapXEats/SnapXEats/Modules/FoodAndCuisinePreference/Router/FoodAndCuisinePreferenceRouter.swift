//
//  FoodPreferenceRouter.swift
//  
//
//  Created by Durgesh Trivedi on 21/02/18.
//  
//

import Foundation
import UIKit

class FoodAndCuisinePreferenceRouter {

    // MARK: Properties

    weak var view: UIViewController?

    static let shared = FoodAndCuisinePreferenceRouter()
    
    private init() {}
    // MARK: Static methods

    func loadFoodAndCuisinePreferenceModule() -> FoodAndCuisinePreferencesViewController {
        
        let viewController = UIStoryboard.loadViewControler(storyBoardName: SnapXEatsStoryboard.userPreferenceStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.cusineAndFoodPreferencesViewControllerID) as! FoodAndCuisinePreferencesViewController
        
        let presenter = FoodAndCuisinePreferencePresenter.shared
        let router = FoodAndCuisinePreferenceRouter.shared
        let interactor = FoodAndCuisinePreferenceInteractor.shared
        
        viewController.presenter =  presenter
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        router.view = viewController
        interactor.output = presenter
        
        return viewController
    }
}

extension FoodAndCuisinePreferenceRouter: FoodAndCuisinePreferenceWireframe {
    // TODO: Implement wireframe methods
}
