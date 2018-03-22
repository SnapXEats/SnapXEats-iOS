//
//  CheckinPopup.swift
//  SnapXEats
//
//  Created by synerzip on 21/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol CheckinPopUpActionsDelegate: class {
    func userDidChekintoRestaurant(restaurant: Restaurant)
}

class CheckinPopup: SnapXEatsView, CheckinPopupView {
    
    private enum popupConstants {
        static let containerRadius: CGFloat = 6.0
    }
    
    weak var checkinPopupDelegate: CheckinPopUpActionsDelegate?
    var presenter: CheckinPopupPresenter?
    var restaurant: Restaurant?
    var router: CheckinPopupRouter?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var checkinButton: UIButton!
    @IBOutlet var restaurantLogoImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func checkinButtonAction(_ sender: UIButton) {
        if let restaurant = self.restaurant, let id = restaurant.restaurant_info_id {
            showLoading()
            presenter?.checkinIntoRestaurant(restaurantId: id)
        }
    }
    
    func setupPopup(frame: CGRect, restaurant: Restaurant) {
        self.frame = frame
        self.restaurant = restaurant
        checkinButton.layer.cornerRadius = checkinButton.frame.height/2
        restaurantLogoImageView.layer.cornerRadius = restaurantLogoImageView.frame.height/2
        containerView.layer.cornerRadius = popupConstants.containerRadius
        if let restaurant = self.restaurant, let name = restaurant.restaurant_name {
            restaurantNameLabel.text = name
        }
    }
    
    override func success(result: Any?) {
        if let success = result as? Bool, success == true {
            self.removeFromSuperview()
            router?.showRewardPointsPopup(parent: self)
        }
    }
}

extension CheckinPopup: RewardPopupActionsDelegate {
    func popupDidDismiss(_ popup: RewardPointsPopup) {
        if let restaurant = self.restaurant {
           checkinPopupDelegate?.userDidChekintoRestaurant(restaurant: restaurant)
        }
    }
}