//
//  RewardPointsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol RewardPopupActionsDelegate: class {
    func popupDidDismiss(_ popup: RewardPointsPopup)
}

class RewardPointsPopup: UIView {

    weak var rewardsPopupDelegate: RewardPopupActionsDelegate?
    
    private enum popupConstants {
        static let containerViewRadius: CGFloat = 5.0
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var okButton: UIButton!
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        rewardsPopupDelegate?.popupDidDismiss(self)
    }
    
    func setupPopup(_ frame: CGRect) {
        self.frame = frame
        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        okButton.addBorder(ofWidth: 2.0, withColor: UIColor.rgba(230.0, 118.0, 7.0, 1.0), radius: okButton.frame.height/2)
        containerView.addShadow()
    }
}
