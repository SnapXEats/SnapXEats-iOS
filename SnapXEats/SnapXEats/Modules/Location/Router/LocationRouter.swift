//
//  LocationRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LocationRouter {

    // MARK: Properties

    private init() {}
    static let singleInstance = LocationRouter()
    weak var view: LocationView?

    // MARK: Static methods

    private func initView(viewController: LocationView) {

        let presenter = LocationPresenter.singleInstance
        let router = LocationRouter.singleInstance
        let interactor = LocationInteractor.singleInstance

        viewController.presenter =  presenter

        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter
    }
}

extension LocationRouter: LocationWireframe {
    func updatedDrawerState(state: KYDrawerController.DrawerState) {
        RootRouter.shared.updateDrawerState(state: state)
    }
    
    func loadLocationModule () -> UINavigationController {
        
        let locationNavigationController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.locationStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.locationNavigationControllerID)
        
        guard let firstViewController = locationNavigationController.viewControllers.first, let viewController = firstViewController as? LocationViewController else {
            return UINavigationController()
        }
        
        initView(viewController: viewController)
        return locationNavigationController
    }
}
