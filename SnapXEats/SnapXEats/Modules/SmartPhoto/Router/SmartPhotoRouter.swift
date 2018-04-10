//
//  smartPhotoRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoRouter {
    
    // MARK: Properties
    
    weak var view: SmartPhotoViewController?
    
    static let shared = SmartPhotoRouter()
    
    private init () {}
    
    func loadModule() -> SmartPhotoViewController {
        let viewController = UIStoryboard.loadViewController() as SmartPhotoViewController
        let presenter = SmartPhotoPresenter.shared
        let router = SmartPhotoRouter.shared
        let interactor = SmartPhotoInteractor.shared
        
        viewController.presenter =  presenter
        
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return viewController
    }
}

extension SmartPhotoRouter: SmartPhotoWireframe {
    func presentSmartPhotoView(view: SmartPhotView) {
        switch view {
        case .info:
             presentInfoView()
        case .audio:
            presentAudioReview()
        case .message:
            presentTextReview()
        case .download:
            presentDownLoadView()
        case .success:
            presentSuccessView()

        }
    }
    
    private func presentInfoView() {
        
    }
    
    private func presentTextReview() {
        
    }
    
    private func presentAudioReview() {
        
    }
    
    private func presentDownLoadView() {
        
    }
    
    func presentSuccessView() {
        
    }
}
