//
//  SmartPhotoDraftRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum DraftScreen {
    case draft, smartPhoto
}

class SmartPhotoDraftRouter {

    // MARK: Properties

    weak var view: UIViewController?

    private init () {}
    static let shared = SmartPhotoDraftRouter()
    // MARK: Static methods

     func loadSmartPhotoDraftModule() -> UINavigationController {
        let draftViewController = UIStoryboard.loadNavigationControler(storyBoardName: SnapXEatsStoryboard.smartPhotoDraft, storyBoardId: SnapXEatsStoryboardIdentifier.smartPhotoDraftNavigationControllerID)
        
        guard let firstViewController = draftViewController.viewControllers.first, let viewController = firstViewController as? SmartPhotoDraftViewController else {
            return UINavigationController()
        }
        let presenter = SmartPhotoDraftPresenter.shared
        let router = SmartPhotoDraftRouter.shared
        let interactor = SmartPhotoDraftInteractor.shared

        viewController.presenter =  presenter

        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor

        router.view = viewController

        interactor.output = presenter

        return draftViewController
    }
    
    func loadDraftTableView() -> DraftTableViewController {
       return  UIStoryboard.loadViewControler(storyBoardName: SnapXEatsStoryboard.smartPhotoDraft, storyBoardId: SnapXEatsStoryboardIdentifier.draftTableViewControllerID) as! DraftTableViewController
    }
    
    func loadSmartPhotoTableView() -> SmartPhotoTableViewController {
        return  UIStoryboard.loadViewControler(storyBoardName: SnapXEatsStoryboard.smartPhotoDraft, storyBoardId: SnapXEatsStoryboardIdentifier.smartPhotoTableViewControllerID) as! SmartPhotoTableViewController
    }
}

extension SmartPhotoDraftRouter: SmartPhotoDraftWireframe {
    func loadScreen(screen: DraftScreen) -> UIViewController {
        switch screen {
        case .draft:
             return loadDraftTableView()
        case .smartPhoto:
            return loadSmartPhotoTableView()
        }
    }
}
