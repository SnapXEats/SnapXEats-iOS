//
//  SnapNShareSocialMediaRouter.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareSocialMediaRouter {

    // MARK: Properties
    weak var view: UIViewController?
    
    static let shared = SnapNShareSocialMediaRouter()
    private init() {}

    // MARK: Static methods
    func loadSnapNshareSocialMediaModule() -> SnapNShareSocialMediaViewController {
        let viewController = UIStoryboard.loadViewController() as SnapNShareSocialMediaViewController
        let presenter = SnapNShareSocialMediaPresenter()
        let router = SnapNShareSocialMediaRouter()
        let interactor = SnapNShareSocialMediaInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension SnapNShareSocialMediaRouter: SnapNShareSocialMediaWireframe {
    // TODO: Implement wireframe methods
}
