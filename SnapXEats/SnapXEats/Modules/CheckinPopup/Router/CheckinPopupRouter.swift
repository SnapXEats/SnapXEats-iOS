//
//  CheckinPopupRouter.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class CheckinPopupRouter {

    // MARK: Properties

    weak var view: UIView?
    static let shared = CheckinPopupRouter()
    private init() {}
    
    // MARK: Static methods

    func loadCheckinPopupModule() -> CheckinPopup {
        
        let checkinPopup = UINib(nibName:SnapXEatsNibNames.checkinPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CheckinPopup
    
        let presenter = CheckinPopupPresenter.shared
        let router = CheckinPopupRouter.shared
        let interactor = CheckinPopupInteractor.shared

        checkinPopup.presenter =  presenter

        presenter.baseView = checkinPopup
        presenter.router = router
        presenter.interactor = interactor
        router.view = checkinPopup
        interactor.output = presenter

        return checkinPopup
    }
}

extension CheckinPopupRouter: CheckinPopupWireframe {
    // TODO: Implement wireframe methods
}
