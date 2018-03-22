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
        checkinPopup.router = router
        
        presenter.baseView = checkinPopup
        presenter.router = router
        presenter.interactor = interactor
        router.view = checkinPopup
        interactor.output = presenter

        return checkinPopup
    }
    
    func showRewardPointsPopup(parent: CheckinPopup) {
        if let window = UIApplication.shared.keyWindow {
            let rewardPointsPopup = UINib(nibName:SnapXEatsNibNames.rewardPointsPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RewardPointsPopup
            rewardPointsPopup.rewardsPopupDelegate = parent
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            rewardPointsPopup.setupPopup(popupFrame)
            window.addSubview(rewardPointsPopup)
        }
    }
}

extension CheckinPopupRouter: CheckinPopupWireframe {
    // TODO: Implement wireframe methods
}
