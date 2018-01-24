//
//  UISearchbar+helper.swift
//  SnapXEats
//
//  Created by synerzip on 24/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
extension UISearchBar {
    
    func setFont(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
}
