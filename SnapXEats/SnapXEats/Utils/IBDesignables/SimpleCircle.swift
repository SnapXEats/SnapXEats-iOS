//
//  CustomCircle.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

@IBDesignable
class SimpleCircle: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
    }
}

