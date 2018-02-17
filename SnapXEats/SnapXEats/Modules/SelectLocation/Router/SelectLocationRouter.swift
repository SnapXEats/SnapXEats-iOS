//
//  SelectLocationRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SelectLocationRouter {

    // MARK: Properties

    weak var view: UIViewController?

    private init() {}
    
    static let singleInstance = SelectLocationRouter()
    // MARK: Static methods

     func loadSelectLocationModule() -> SelectLocationViewController {
        let viewController = UIStoryboard.loadViewController() as SelectLocationViewController
        let presenter = SelectLocationPresenter.singleInstance
        let router = SelectLocationRouter.singleInstance
        let interactor = SelectLocationInteractor.singleInstance

        viewController.presenter =  presenter

        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return viewController
    }
}

extension SelectLocationRouter: SelectLocationWireframe {
    func presentScreen(screen: Screens) {
        RootRouter.shared.presentScreen(screens: screen)
    }
}
