//
//  Date+Helpers.swift
//  SnapXEats
//
//  Created by synerzip on 21/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
