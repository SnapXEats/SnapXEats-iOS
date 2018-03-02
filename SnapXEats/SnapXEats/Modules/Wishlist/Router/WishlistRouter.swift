//
//  WishlistRouter.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class WishlistRouter {

    // MARK: Properties

    weak var view: UIViewController?
    static let shared = WishlistRouter()
    private init() {}
    
    func loadWishlistModule() -> UINavigationController {
        
        let wishlistNVController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.wishlist, storyBoardId: SnapXEatsStoryboardIdentifier.wishlistNavigationControllerID)
        
        guard let firstViewController = wishlistNVController.viewControllers.first, let viewController = firstViewController as? WishlistViewController else {
            return UINavigationController()
        }
        
        let presenter = WishlistPresenter.shared
        let router = WishlistRouter.shared
        let interactor = WishlistInteractor.shared
        
        viewController.presenter =  presenter
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return wishlistNVController
    }
}

extension WishlistRouter: WishlistWireframe {
    // TODO: Implement wireframe methods
}
