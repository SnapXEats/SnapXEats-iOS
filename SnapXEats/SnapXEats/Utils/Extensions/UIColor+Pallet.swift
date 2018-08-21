//
//  UIColor+Pallet.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

extension UIColor {
    
    static var hotPink: UIColor {
        return UIColor("#f0008c")
    }
        
    static var azure: UIColor {
        return UIColor("#00adf2")
    }
    
    static var pea: UIColor {
        return UIColor("#b6d624")
    }
    
    static var pumpkinOrange: UIColor {
        return UIColor("#f78200")
    }
    static var backgroundGrey: UIColor {
        return UIColor("#f6f6f6")
    }
    
    static var tomato: UIColor {
        return UIColor("#e7372d")
    }
    
    static var pinkishGrey: UIColor {
        return UIColor("#d1d1d1")
    }
    
    static var coolGrey: UIColor {
        return UIColor("#AFAFB0")
    }
    
    static var steel: UIColor {
        return UIColor("#8e8e8f")
    } 
    
    static var silver: UIColor {
        return UIColor("#E4E4E5")
    }
    
    static var bubbleGum: UIColor {
        return UIColor("#fb70bf")
    }
    
    static var headerCell: UIColor {
        return UIColor("#636262")
    }
    
    static func rgba(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
