//
//  LocationStoreHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 26/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class LocationStoreHelper {
    static let shared = LocationStoreHelper()
    private init() {}
    
    func storeLocation(location: LocationModel) {
        if let userID = location.userID {
            let predicate  =  NSPredicate(format: "userID == %@", userID)
            LocationStore.createSmartPhotoData(location: mapLocationStore(location: location), predicate: predicate)
        }
    }
    
    func mapLocationStore(location: LocationModel) -> LocationStore {
        let locationStore = LocationStore()
        locationStore.latitue = location.latitue
        locationStore.logitude = location.logitude
        locationStore.placeName = location.placeName
        locationStore.userID = location.userID
        return locationStore
    }
    
    func getStoredLocation(userID: String) -> LocationModel? {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        if let locationStore = LocationStore.getLocation(predicate: predicate) {
            return mapLocationModel(locationStore: locationStore)
        }
        return nil
    }
    
    func mapLocationModel(locationStore: LocationStore) -> LocationModel {
        let location = LocationModel()
        location.latitue = locationStore.latitue
        location.logitude = locationStore.logitude
        location.placeName = locationStore.placeName
        location.userID = locationStore.userID
        return location
    }
}
