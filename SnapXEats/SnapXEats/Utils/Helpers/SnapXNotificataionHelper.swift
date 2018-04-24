//
//  NotificataionHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 24/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UserNotifications

@available(iOS 10.0, *)
class SnapXNotificataionHelper {
    
    static let shared = SnapXNotificataionHelper()
    private init() {}
    
    func scheduleNotification(userInfo: [AnyHashable: Any]) {
        
        let content = UNMutableNotificationContent()
        let requestIdentifier = NotificationConstant.requestIdentifier
        content.userInfo = userInfo
        content.badge = 1
        content.title = NotificationConstant.messageTitle
        content.subtitle = NotificationConstant.messageSubTitle
        content.body = NotificationConstant.messageBody
        content.categoryIdentifier = NotificationConstant.catogories
        content.sound = UNNotificationSound.default()
        
        // If you want to attach any image to show in local notification
        //        let url = Bundle.main.url(forResource: "Icon-App-20x20", withExtension: ".png")
        //        do {
        //            let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
        //            content.attachments = [attachment!]
        //        }
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func registerReminderNotification(restaurantID: String) {
        var userInfo: [AnyHashable: Any] = [:]
        userInfo = [SnapXEatsConstant.restaurantID : restaurantID]
        
        //actions defination
        let reminder = UNNotificationAction(identifier: NotificationConstant.remindLater, title: NotificationConstant.remindTitle, options: [.foreground])
        let takePhoto = UNNotificationAction(identifier: NotificationConstant.takePhoto, title: NotificationConstant.photoTitle, options: [.foreground])
        
        let category = UNNotificationCategory(identifier: NotificationConstant.catogories, actions: [reminder, takePhoto], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        SnapXNotificataionHelper.shared.scheduleNotification(userInfo: userInfo)
    }
}
