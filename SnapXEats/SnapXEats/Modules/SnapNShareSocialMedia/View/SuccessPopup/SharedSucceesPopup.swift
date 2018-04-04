//
//  RewardPointsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol SharedSucceesActionsDelegate: class {
    func movetoSnapNShareScreen(restaurantID: String)
    func popupDidDismiss()
}

class SharedSucceesPopup: UIView {

    weak var sharedSuccessDelegate: SharedSucceesActionsDelegate?
    var restaurantID: String?

    
    @IBOutlet var containerView: UIView!
    @IBOutlet var notNowButton: UIButton!
    @IBOutlet var sharedAnotherButton: UIButton!
    
    @IBAction func notNowButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        sharedSuccessDelegate?.popupDidDismiss()
    }
    
    @IBAction func sharedAnotherAction(_ sender: UIButton) {
        self.removeFromSuperview()
        if let id = restaurantID {
            sharedSuccessDelegate?.movetoSnapNShareScreen(restaurantID: id)
        }
    }
    
    func setupPopup(_ frame: CGRect, rewardPoints: Int) {
        self.frame = frame
        containerView.layer.cornerRadius = PopupConstants.containerViewRadius
        sharedAnotherButton.addBorder(ofWidth: 2.0, withColor: UIColor.rgba(230.0, 118.0, 7.0, 1.0), radius: sharedAnotherButton.frame.height/2)
        containerView.addShadow()
    }
}
