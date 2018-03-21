//
//  UIButton+Helper.swift
//  SnapXEats
//
//  Created by synerzip on 20/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func isActive() {
        self.isEnabled = true
        self.isHidden = false
        self.alpha = 1.0
    }
    
    func isInactive() {
        self.isEnabled = false
        self.isHidden = true
    }
}
