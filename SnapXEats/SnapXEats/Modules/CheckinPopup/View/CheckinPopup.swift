//
//  CheckinPopup.swift
//  SnapXEats
//
//  Created by synerzip on 21/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol CheckinPopUpActionsDelegate: class {
    func userDidChekin(_ popup: CheckinPopup)
}

class CheckinPopup: SnapXEatsView, CheckinPopupView {
    
    private enum popupConstants {
        static let containerRadius: CGFloat = 6.0
    }
    
    weak var checkinPopupDelegate: CheckinPopUpActionsDelegate?
    var presenter: CheckinPopupPresenter?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var checkinButton: UIButton!
    @IBOutlet var restaurantLogoImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func checkinButtonAction(_ sender: UIButton) {
        showLoading()
        presenter?.checkinIntoRestaurant(restaurantId: "62dfee80-b52b-482f-b0f3-c175ce5d56ca")
    }
    
    func setupPopup(frame: CGRect) {
        self.frame = frame
        checkinButton.layer.cornerRadius = checkinButton.frame.height/2
        restaurantLogoImageView.layer.cornerRadius = restaurantLogoImageView.frame.height/2
        containerView.layer.cornerRadius = popupConstants.containerRadius
    }
    
    override func success(result: Any?) {
        if let success = result as? Bool, success == true {
            self.removeFromSuperview()
            checkinPopupDelegate?.userDidChekin(self)
        }
    }
}
