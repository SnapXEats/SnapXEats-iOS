//
//  UIImage+Icons.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

extension UIImage {
    
    static var addIcon: UIImage {
        return UIImage(named: "icAddButton")!
    }
    
    static var addBlueIcon: UIImage {
        return UIImage(named: "icAddBlueButton")!
    }
    
    static var closeIcon: UIImage {
        return UIImage(named: "icCloseButton")!
    }
    
    static var backIcon: UIImage {
        return UIImage(named: "icBackButton")!
    }
    
    static var paymentIcon: UIImage {
        return UIImage(named: "icCheckboxButton")!
    }
    
    static var unselectIcon: UIImage {
        return UIImage(named: "icCheckButtonEmpty")!
    }
    
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
