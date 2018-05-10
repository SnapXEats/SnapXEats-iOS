//
//  BackGroundLocationHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 02/05/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BackgroundLocationHelper: NSObject, CLLocationManagerDelegate {
    
    static let shared = BackgroundLocationHelper()
    static let BACKGROUND_TIMER =  150.0 // restart location manager every 150 seconds
    static let UPDATE_LOCATION_INTERVAL = 120 // Check if reached the location or not  every 2 min
    
    let locationManager = CLLocationManager()
    var timer: Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate  = Date()
    
    private override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    @objc func applicationEnterBackground(){
        start()
    }
    
    func start(){
        initValue()
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func initValue() {
         locationManager.delegate = self
        guard let _ = UserDefaults.standard.value(forKey: NotificationConstant.snapXEatsTravelStartTime) as? String else {
            if #available(iOS 9, *){
                locationManager.allowsBackgroundLocationUpdates = true
            }
            let date = Date().timeIntervalSince1970.string
            UserDefaults.standard.set(date, forKey: NotificationConstant.snapXEatsTravelStartTime)
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            return
        }
    }
    
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }
    
    func stopeMoniteringLocation() -> Bool {
        if let checkInTime =  UserDefaults.standard.value(forKey: NotificationConstant.snapXEatsTravelStartTime) as? String,
            let time = TimeInterval.init(checkInTime)  {
                let timeInterval = Date().timeIntervalSince1970
                if (timeInterval - time ) >=  CheckOutContant.stopMonitoring { //2 hour for auto checkout
                   reset()
                   return true
                }
            }
         return false
        }
        
        func reset() {
            timer?.invalidate()
            timer = nil
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            if #available(iOS 9, *){
                locationManager.allowsBackgroundLocationUpdates = false
            }
            
            if let taskId = currentBgTaskId {
                UIApplication.shared.endBackgroundTask(taskId)
                currentBgTaskId = UIBackgroundTaskInvalid
            }
            
            NotificationCenter.default.removeObserver(self)
            UserDefaults.standard.removeObject(forKey: NotificationConstant.snapXEatsTravelStartTime)
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .restricted:
                print("Restricted")
            //log("Restricted Access to location")
            case .denied:
                print("Denied")
            case .notDetermined:
                print("NotDetermined")
            default:
                //log("startUpdatintLocation")
                if #available(iOS 9, *){
                    locationManager.requestLocation()
                } else {
                    locationManager.startUpdatingLocation()
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             //stop monitoring location after 2 hours automatic
            if(timer == nil && !stopeMoniteringLocation()) {
                // The locations array is sorted in chronologically ascending order, so the
                // last element is the most recent
                guard let location = locations.last else {return}
                
                beginNewBackgroundTask()
                locationManager.stopUpdatingLocation()
                let now = Date()
                if(isItTime(now: now)) {
                    
                    if let restaurant = CheckInHelper.shared.checkInRestaurant,
                        let lat = restaurant.latitude, lat != 0.0, let long = restaurant.longitude, long != 0.0 {
                         //18.502888899999999  karisma location// 18.499319908838075  Kothrud location   //restaurant.latitude
                         //73.821495634414759  karisma location // 73.821412665721184 //Kothrud location // //restaurant.longitude
                        let restaurantLocation = CLLocation(latitude: lat, longitude: long)
                        if distancIs50Miter(userLocation: location, restaurantLocation: restaurantLocation) {
                            if #available(iOS 10.0, *) {
                                SnapXNotificataionHelper.shared.registerCheckInNotification(restaurant: restaurant)
                                reset()
                            }
                        }
                    }
                }
            }
        }
        
        func distancIs50Miter(userLocation: CLLocation, restaurantLocation: CLLocation) -> Bool {
            let distance = userLocation.distance(from: restaurantLocation)
            return  distance <= 50.0 ? true : false
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
        }
        
        func isItTime(now: Date) -> Bool {
            let timePast = now.timeIntervalSince(lastLocationDate)
            let intervalExceeded = Int(timePast) > BackgroundLocationHelper.UPDATE_LOCATION_INTERVAL
            return intervalExceeded;
        }
        
        func beginNewBackgroundTask(){
            var previousTaskId = currentBgTaskId;
            currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                print("task expired: ")
            })
            if let taskId = previousTaskId {
                UIApplication.shared.endBackgroundTask(taskId)
                previousTaskId = UIBackgroundTaskInvalid
            }
            
            timer = Timer.scheduledTimer(timeInterval: BackgroundLocationHelper.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
        }
}
