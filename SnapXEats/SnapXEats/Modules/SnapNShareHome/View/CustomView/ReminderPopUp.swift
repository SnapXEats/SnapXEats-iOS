//
//  RewardPointsPopup.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import UserNotifications

protocol CameraMode: class {
    func showCamera()
}


protocol ReminderNotification: class {
    
    @available(iOS 10.0, *)
    func regiterNotification(restaurantID: String)
}

class ReminderPopUp: UIView {
    
    var restaurantID: String?
    weak var cameraDelegate: CameraMode?
    weak var notificationDelegate: ReminderNotification?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var remindlaterButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    weak var parentView: SnapNShareHomeViewController?
    @IBAction func remindLaterButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
        if let id = restaurantID, #available(iOS 10.0, *) {
            notificationDelegate?.regiterNotification(restaurantID: id)
        }
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        self.removeFromSuperview()
        cameraDelegate?.showCamera()
    }
    
    func setupPopup(_ frame: CGRect, rewardPoints: Int) {
        self.frame = frame
        containerView.layer.cornerRadius = PopupConstants.containerViewRadius
        takePhotoButton.addBorder(ofWidth: 2.0, withColor: UIColor.rgba(230.0, 118.0, 7.0, 1.0), radius: takePhotoButton.frame.height/2)
        containerView.addShadow()
    }
    
    
}
