//
//  UserPreferenceRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class UserPreferenceRouter {

    // MARK: Properties

    weak var view: UIViewController?
    static let shared = UserPreferenceRouter()
   
    // MARK: Static methods

    func loadUserPreferenceModule() -> UINavigationController {
        
        let userPreferenceNVController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.userPreferenceStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.userPreferenceNavigationControllerID)
        
        guard let firstViewController = userPreferenceNVController.viewControllers.first, let viewController = firstViewController as? UserPreferenceViewController else {
            return UINavigationController()
        }
        
        let presenter = UserPreferencePresenter.shared
        let router = UserPreferenceRouter.shared
        let interactor = UserPreferenceInteractor.shared

        viewController.presenter =  presenter
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return userPreferenceNVController
    }
}

extension UserPreferenceRouter: UserPreferenceWireframe {
    // TODO: Implement wireframe methods
}
