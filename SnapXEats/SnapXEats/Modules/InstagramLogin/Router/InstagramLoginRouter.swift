//
//  InstagramLoginRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class InstagramLoginRouter {

    weak var view: UIViewController?

    private init() {}
    
    static let shared = InstagramLoginRouter()

}

extension InstagramLoginRouter: InstagramLoginWireframe {
    
     func loadInstagramView() -> InstagramLoginView {
        let viewController = UIStoryboard.loadViewControler(storyBoardName: SnapXEatsStoryboard.loginStoryboard, storyBoardId: SnapXEatsStoryboardIdentifier.instagramViewControllerID) as! InstagramLoginViewController
       
        let presenter = InstagramLoginPresenter.shared
        let router = InstagramLoginRouter.shared
        let interactor = InstagramLoginInteractor.shared
        
        viewController.presenter =  presenter
        
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return viewController
    }
}
