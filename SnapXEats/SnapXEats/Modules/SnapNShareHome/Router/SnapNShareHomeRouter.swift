//
//  SnapNShareHomeRouter.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareHomeRouter {

    // MARK: Properties

    weak var view: UIViewController?
    static let shared = SnapNShareHomeRouter()
    private init() {}

    // MARK: Static methods

    func loadSnapNShareHomeModule() -> UINavigationController {
        
        let snapNShareHomeNVController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.snapNShareHome, storyBoardId: SnapXEatsStoryboardIdentifier.snapNShareHomeNvControllerID)
        
        guard let firstViewController = snapNShareHomeNVController.viewControllers.first, let viewController = firstViewController as? SnapNShareHomeViewController else {
            return UINavigationController()
        }
        
        let presenter = SnapNShareHomePresenter.shared
        let router = SnapNShareHomeRouter.shared
        let interactor = SnapNShareHomeInteractor.shared

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return snapNShareHomeNVController
    }
}

extension SnapNShareHomeRouter: SnapNShareHomeWireframe {
    // TODO: Implement wireframe methods
}
