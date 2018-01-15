//
//  UIFont+Utils.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

extension UIFont {
    
    static func SFTextRegular(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Constants.Font.SFTextRegular, size: size)
    }
    
    static func SFTextLight(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Constants.Font.SFTextLight, size: size)
    }
    
    static func SFTextMedium(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Constants.Font.SFTextMedium, size: size)
    }
    

}
