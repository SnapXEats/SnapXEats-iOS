//
//  Constants.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import Foundation


enum Constants {
    
    enum URL {
        static let baseURL = "http://snapXEats.com"
        static let signUp = baseURL + ""
        static let login = baseURL + "auth/"
    }
    
    enum Label {
        static let padding = CGFloat(10)
        static let edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
    }
    
    enum Font {
        static let SFTextLight = "SanFranciscoText-Light"
        static let SFTextMedium = "SanFranciscoText-Medium"
        static let SFTextRegular = "SanFranciscoText-Regular"
    }

}
