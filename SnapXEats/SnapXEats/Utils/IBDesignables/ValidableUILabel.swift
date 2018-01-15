//
//  PinkUILabel.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

@IBDesignable
class ValidableUILabel: UILabel {
    
    var isItsTextFieldInvalid = true
    
    func resetLabelColor(toColor color: UIColor? = UIColor.bubbleGum) {
        isItsTextFieldInvalid ? (textColor = color) : ()
        isItsTextFieldInvalid = false
    }
    
    func highlightLabelColor() {
        textColor = UIColor.tomato
        isItsTextFieldInvalid = true
    }
}

