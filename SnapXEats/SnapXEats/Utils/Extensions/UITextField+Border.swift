//
//  UITextField+Border.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
import UIKit


extension UITextField {
    
    func resetTextFieldBorder() {
        layer.borderColor = UIColor.pinkishGrey.cgColor
        layer.borderWidth = 0.5
    }
    
    func highlightTextFieldBorder() {
        layer.borderColor = UIColor.tomato.cgColor
        layer.borderWidth = 1.0
    }
    
    func disable() {
        self.alpha = 0.5
        self.backgroundColor = UIColor.silver
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.alpha = 1.0
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}
