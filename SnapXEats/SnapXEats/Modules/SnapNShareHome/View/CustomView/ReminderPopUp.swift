//
//  RewardPointsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol ReminderPopUpDelegate: class {
    func startReminder()
    func stopReminder()
}

class ReminderPopUp: UIView {

    weak var reminderPopUpDelegate: ReminderPopUpDelegate?
    var restaurantID: String?

    
    @IBOutlet var containerView: UIView!
    @IBOutlet var remindlaterButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    
    @IBAction func remindLaterButtonAction(_ sender: UIButton) {
        reminderPopUpDelegate?.startReminder()
        self.removeFromSuperview()
        
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func setupPopup(_ frame: CGRect, rewardPoints: Int) {
        self.frame = frame
        containerView.layer.cornerRadius = PopupConstants.containerViewRadius
        takePhotoButton.addBorder(ofWidth: 2.0, withColor: UIColor.rgba(230.0, 118.0, 7.0, 1.0), radius: takePhotoButton.frame.height/2)
        containerView.addShadow()
    }
}
