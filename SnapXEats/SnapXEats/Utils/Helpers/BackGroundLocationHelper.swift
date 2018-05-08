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
    static let BACKGROUND_TIMER = 120.0 // restart location manager every 150 seconds
    static let UPDATE_LOCATION_INTERVAL = 5 //60 * 60 // 1 hour - once every 1 hour send location to server
    
    let locationManager = CLLocationManager()
    var timer: Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate  = Date()
    
    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
        }
        locationManager.pausesLocationUpdatesAutomatically = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func applicationEnterBackground(){
        // FileLogger.log("applicationEnterBackground")
        start()
    }
    
    func start(){
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
    
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
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
        
        if(timer == nil) {
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard let location = locations.last else {return}
            
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = Date()
            if(isItTime(now: now)){
                if let restaurant = CheckInHelper.shared.checkInRestaurant, restaurant.latitude != 0.0, restaurant.longitude != 0.0 {
                    let lat = 18.499351847376033   //restaurant.latitude
                    let long =  73.821495634414759 //restaurant.longitude
                    let restaurantLocation = CLLocation(latitude: lat, longitude: long)
                    if distancIs10Miter(userLocation: location, restaurantLocation: restaurantLocation) {
                        if #available(iOS 10.0, *) {
                            SnapXNotificataionHelper.shared.registerCheckInNotification(restaurant: restaurant)
                        }
                    }
                }
            }
        }
    }
    
    func distancIs10Miter(userLocation: CLLocation, restaurantLocation: CLLocation) -> Bool {
        let distance = userLocation.distance(from: restaurantLocation)
        return  distance <= 10.0 ? true : false
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
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskInvalid
        }
        
        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationHelper.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
}
