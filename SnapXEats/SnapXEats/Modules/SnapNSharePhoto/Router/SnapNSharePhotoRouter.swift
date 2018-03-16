//
//  SnapNSharePhotoRouter.swift
//  SnapXEats
//
//  Created by synerzip on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNSharePhotoRouter {

    // MARK: Properties
    weak var view: UIViewController?

    static let shared = SnapNSharePhotoRouter()
    private init() {}
    
    // MARK: Static methods
    func loadSnapNSharePhotoModule() -> SnapNSharePhotoViewController {
        let viewController = UIStoryboard.loadViewController() as SnapNSharePhotoViewController
        let presenter = SnapNSharePhotoPresenter()
        let router = SnapNSharePhotoRouter()
        let interactor = SnapNSharePhotoInteractor()

        viewController.presenter =  presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension SnapNSharePhotoRouter: SnapNSharePhotoWireframe {
    // TODO: Implement wireframe methods
}
