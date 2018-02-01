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

    // MARK: Static methods

    static func setupModule() -> UserPreferenceViewController {
        let viewController = UIStoryboard.loadViewController() as UserPreferenceViewController
        let presenter = UserPreferencePresenter()
        let router = UserPreferenceRouter()
        let interactor = UserPreferenceInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension UserPreferenceRouter: UserPreferenceWireframe {
    // TODO: Implement wireframe methods
}
