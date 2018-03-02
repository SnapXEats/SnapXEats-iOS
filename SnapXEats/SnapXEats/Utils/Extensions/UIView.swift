//
//  UIView.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

extension UIView {
    
    enum ViewSides {
        case top
        case bottom
        case left
        case right
    }
    
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
    
    func addShadow(width: CGFloat = 1.0, height: CGFloat = 1.0) {
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.rgba(202.0, 202.0, 202.0, 1).cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.masksToBounds = false
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func addViewBorderWithColor(color: UIColor, width: CGFloat, side: ViewSides) {
        var frame = CGRect()
        switch side {
            case .top: frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
            case .bottom: frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
            case .left: frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
            case .right: frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        }
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = frame
        self.layer.addSublayer(border)
    }
    
    func fullShadow(color: UIColor, opacity: Float = 0.7, offSet: CGSize, radius: CGFloat = 1) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
}
