//
//  SnapXEatsLocation.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 05/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct UserPreference {
    let preference = SelectedPreference.shared
    let locationManager = CLLocationManager()
}

protocol SelectedUserPreference: class {
    var userPreference: UserPreference {get}
}
protocol SnapXEatsUserLocation: NetworkFailure, SelectedUserPreference {
    
    var currentView: UIViewController {get}
    func checkLocationStatus()
    func showSettingDialog()
    func showAddressForLocation(locations: [CLLocation], completionHandler: @escaping (_ error: NetworkResult) -> ())
}

extension SnapXEatsUserLocation {
    
    var selectedPreference: SelectedPreference {
        get {
            return userPreference.preference
        }
    }
    
    var locationManager: CLLocationManager {
        get {
            return userPreference.locationManager
        }
    }
    
    var permissionDenied: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SnapXEatsConstant.onceDeniedLocation)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: SnapXEatsConstant.onceDeniedLocation)
        }
    }
    
    func showSettingDialog() {
        let status = CLLocationManager.authorizationStatus()
        let currenctStatus = (status  == .denied ||  status  == .restricted)
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if   locationServicesEnabled == false {
            SnapXAlert.singleInstance.showLoationSettingDialog(forView: currentView, settingString: SnapXEatsSettingsURL.deviceLocationSetting) { /*Empty block */}
        } else if locationServicesEnabled && currenctStatus && permissionDenied {
            SnapXAlert.singleInstance.showLoationSettingDialog(forView: currentView, settingString: SnapXEatsSettingsURL.appLocationSettings) { /*Empty block */}
        } else {
            checkLocationStatus()
        }
    }
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func showAddressForLocation(locations: [CLLocation], completionHandler: @escaping (_ result: NetworkResult ) -> ()) {
        let location = locations.first!
        stopLocationManager()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {(placemarksArray, error) in
            if self.checkRechability() {
                if let placemarksArray = placemarksArray, placemarksArray.count > 0 { // app was crashin on on/off internet
                    let placemark = placemarksArray.first // Get the First Address from List
                    self.selectedPreference.location.latitude =  Double(placemark?.location?.coordinate.latitude ?? 0)
                    self.selectedPreference.location.longitude = Double(placemark?.location?.coordinate.longitude ?? 0)
                    let result: (String?, String?) = (subLocality: placemark?.subLocality, subAdministrativeArea : placemark?.subAdministrativeArea)
                    completionHandler(.success(data: result))
                } else {
                    completionHandler(.noInternet)
                }
                
            }
        }
    }
}
