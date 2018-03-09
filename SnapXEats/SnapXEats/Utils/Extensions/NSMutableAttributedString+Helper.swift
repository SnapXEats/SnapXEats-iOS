//
//  NSMutableAttributedString+Helper.swift
//  SnapXEats
//
//  Created by synerzip on 09/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
    }
}
