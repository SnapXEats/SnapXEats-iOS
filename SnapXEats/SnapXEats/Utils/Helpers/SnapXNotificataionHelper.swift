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
//https://stackoverflow.com/questions/39713605/getting-local-notifications-to-show-while-app-is-in-foreground-swift-3
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
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: NotificationConstant.notificationTimer, repeats: false)
        
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
    
    
    func scheduleCheckInNotification(userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        let requestIdentifier = NotificationConstant.chekINrequestIdentifier
        content.userInfo = userInfo
        content.badge = 1
        content.title = NotificationConstant.checkInTitle
        content.subtitle = NotificationConstant.checkInSubTitle
        content.body = NotificationConstant.checkINBody
        content.categoryIdentifier = NotificationConstant.checkInCatogories
        content.sound = UNNotificationSound.default()
        
        // imidately fire notification on arrival
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func registerCheckInNotification(restaurant: CheckInRestaurant) {
        var userInfo: [AnyHashable: Any] = [:]
        userInfo = [NotificationConstant.checkINRestaurantID : createRestaurantDictionary(restaurant: restaurant)]
        let category = UNNotificationCategory(identifier: NotificationConstant.checkInCatogories, actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        SnapXNotificataionHelper.shared.scheduleCheckInNotification(userInfo: userInfo)
    }
    
    func createRestaurantDictionary(restaurant: CheckInRestaurant) -> [String: Any] {
        let restaurant: [String: Any] = [NSCoderKeys.restaurantId: restaurant.restaurantId ?? "",
                                         NSCoderKeys.name: restaurant.name ?? "",
                                         NSCoderKeys.latitude: restaurant.latitude ?? 0.0,
                                         NSCoderKeys.longitude: restaurant.longitude ?? 0.0,
                                         NSCoderKeys.price: restaurant.price ?? 0,
                                         NSCoderKeys.type: restaurant.type ?? "",
                                         NSCoderKeys.logoImage: restaurant.logoImage ?? ""]
        return restaurant
    }
    
    func createRestaurantData(userInfo: [AnyHashable: Any]) -> CheckInRestaurant? {
        if let restaurant: [String: Any] = userInfo[NotificationConstant.checkINRestaurantID] as? [String: Any] {
            let checkINrestaurant =  CheckInRestaurant()
            checkINrestaurant.restaurantId = restaurant[NSCoderKeys.restaurantId] as? String
            checkINrestaurant.name = restaurant[NSCoderKeys.name] as? String
            checkINrestaurant.latitude = restaurant[NSCoderKeys.latitude] as? Double
            checkINrestaurant.longitude = restaurant[NSCoderKeys.longitude] as? Double
            checkINrestaurant.price = restaurant[NSCoderKeys.price] as? Int
            checkINrestaurant.type = restaurant[NSCoderKeys.type] as? String
            checkINrestaurant.logoImage = restaurant[NSCoderKeys.logoImage] as? String
            return checkINrestaurant
        }
        return nil
    }
    
    func removePendingNotification(requestIdentifier: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == requestIdentifier {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func removeDeliveredNotification(requestIdentifier: String) {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotification in notificationRequests {
                if notification.request.identifier == requestIdentifier {
                    identifiers.append(notification.request.identifier)
                }
            }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        }
    }
    
}
