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
        let presenter = SnapNShareSocialMediaPresenter.shared
        let router = SnapNShareSocialMediaRouter.shared
        let interactor = SnapNShareSocialMediaInteractor.shared

        viewController.presenter =  presenter

        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
    
    func createNavigationController() -> UINavigationController {
        let navigationController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.locationStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.locationNavigationControllerID)
        
        //navigationController.viewControllers.removeAll()
        navigationController.viewControllers.append(loadSnapNshareSocialMediaModule())
        return navigationController
    }
}

extension SnapNShareSocialMediaRouter: SnapNShareSocialMediaWireframe {
    // TODO: Implement wireframe methods
}

extension SnapNShareSocialMediaRouter {
    func loadSharedSuccessPopup() -> SharedSucceesPopup {
        let sharedSucceesPopup = UINib(nibName:SnapXEatsNibNames.sharedSucceesPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SharedSucceesPopup
        return sharedSucceesPopup
    }
}
