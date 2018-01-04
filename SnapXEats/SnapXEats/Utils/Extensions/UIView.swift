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
}
