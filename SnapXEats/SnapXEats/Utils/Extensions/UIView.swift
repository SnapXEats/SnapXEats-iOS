//
//  UIView.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

extension UIView {
    
    func superview<T>(ofType type: T.Type) -> T? where T: UIView {
        return superview as? T ?? superview?.superview(ofType: type)
    }
    
    func subviews<T>(ofType type: T.Type) -> [T] where T: UIView {
        var subviews: [T] = []
        for view in self.subviews {
            if let tView = view as? T {
                subviews.append(tView)
            }
            let viewSubviews = view.subviews(ofType: T.self)
            subviews = Array([subviews, viewSubviews].joined())
        }
        return subviews
    }
    
    /**
     Add border to the button on exam detail view whether exam step is completed or fail, green color for complete operation and red color for operation failed
     
     - parameters:
     - width:    Width of border
     - color:    Color for border
     - returns: Void
     */
    func addBorder(ofWidth width: CGFloat = 1.0, withColor color: UIColor = .black, radius: CGFloat = 0.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
    }
    
    func addShadow() {
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.rgba(202.0, 202.0, 202.0, 1).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
}
