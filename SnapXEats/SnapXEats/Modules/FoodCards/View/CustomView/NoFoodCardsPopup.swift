//
//  NoFoodCardsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 29/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol NofoodCardActionsDelegate: class {
    func didSelectSetPreferences(_ popup: NoFoodCardsPopup)
    func didSelectSetCuisine(_ popup: NoFoodCardsPopup)
}

class NoFoodCardsPopup: UIView {

    weak var noFoodCardsPopupDelegate: NofoodCardActionsDelegate?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var setPreferencesButton: UIButton!
    @IBOutlet var selectCuisineButton: UIButton!
    
    @IBAction func setPreferencesButtonaction(_ sender: UIButton) {
        noFoodCardsPopupDelegate?.didSelectSetPreferences(self)
    }
    
    @IBAction func selectcuisineButtonaction(_ sender: UIButton) {
        noFoodCardsPopupDelegate?.didSelectSetCuisine(self)
    }
    
    func setupPopup(_ frame: CGRect) {
        self.frame = frame
        setPreferencesButton.layer.cornerRadius = setPreferencesButton.frame.height/2
        containerView.layer.cornerRadius = 5.0
        containerView.addShadow()
    }
}
