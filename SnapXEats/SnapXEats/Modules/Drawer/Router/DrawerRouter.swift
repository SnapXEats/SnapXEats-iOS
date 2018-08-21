//
//  DrawerRouter.swift
//  
//
//  Created by Durgesh Trivedi on 22/02/18.
//  
//

import Foundation
import UIKit

class DrawerRouter {

    // MARK: Properties
    static let shared = DrawerRouter()
    private init() {}
    weak var view: UIViewController?

    // MARK: Static methods

    func loadDrawerMenu() -> DrawerViewController {
        let storyboard = UIStoryboard(name: SnapXEatsStoryboard.drawer, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SnapXEatsStoryboardIdentifier.drawerViewController) as! DrawerViewController
        
        let presenter = DrawerPresenter.shared
        let router = DrawerRouter.shared
        let interactor = DrawerInteractor.shared

        viewController.presenter =  presenter

        router.view = viewController
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor


        interactor.output = presenter

        return viewController
    }
}


extension DrawerRouter: DrawerWireframe {
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState) {
       RootRouter.shared.presentScreen(screen: screen, drawerState: drawerState)
    }
}
