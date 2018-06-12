//
//  NoFoodCardsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 29/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class NoNearByRestaurantPopup: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var okButton: UIButton!
    
    
    @IBAction func setPreferencesButtonaction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func setupPopup(_ frame: CGRect) {
        self.frame = frame
        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        okButton.addBorder(ofWidth: 2.0, withColor: UIColor.rgba(230.0, 118.0, 7.0, 1.0), radius: okButton.frame.height/2)
        containerView.addShadow()
    }
}
