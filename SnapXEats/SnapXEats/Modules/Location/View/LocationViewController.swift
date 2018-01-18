//
//  LocationViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class LocationViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: LocationPresentation?

    // MARK: Lifecycle
    var locationManager: CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension LocationViewController: LocationView {
    // TODO: implement view output methods
    func initView() {
        locationManager = CLLocationManager()
        isAuthorizedtoGetUserLocation()
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        } else  if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }//if authorized
    }

    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        //store the user location here to firebase or somewhere
    }
    
}
