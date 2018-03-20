//
//  DateFormatters.swift
//  SnapXEats
//
//  Created by synerzip on 27/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

func formatDateFromString(datestr: String) -> String {
    var formattedDate = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //Date Format from Server side
    
    if let currentDate = dateFormatter.date(from: datestr) {
        dateFormatter.dateFormat = "dd MMM yyyy"
        formattedDate = dateFormatter.string(from: currentDate)
    }
    return formattedDate
}

func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / timeFormatConstants.timeConversionFactor % timeFormatConstants.timeConversionFactor
    let seconds = Int(time) % timeFormatConstants.timeConversionFactor
    return String(format:timeFormatConstants.displayTimerFormat,minutes, seconds)
}
