//
//  LocationStore.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 26/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class LocationStore: Object {
    @objc dynamic var latitue = 0.0
    @objc dynamic var logitude = 0.0
    @objc dynamic var placeName: String?
    @objc dynamic var userID: String?

    static func createSmartPhotoData(location: LocationStore, predicate: NSPredicate) {
        if let _ = location.userID, let place = location.placeName,
            location.userID != SnapXEatsConstant.emptyString, place != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
                if  let _ = LocationStore.getLocation(predicate: predicate)  {
                    updateLocation(newLocation: location, predicate: predicate)
                }
                let realm = try! Realm()
                // Persist your data easily
                try! realm.write {
                    realm.add(location)
                }
            }
        }
    }
    
    static func getLocation(predicate: NSPredicate) -> LocationStore?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result = realm.objects(LocationStore.self).filter(predicate)
        return result.first
        
    }
    
    static func updateLocation(newLocation: LocationStore, predicate: NSPredicate) {
        let realm = try! Realm()
        if let location = getLocation(predicate: predicate) {
            try! realm.write {
                location.latitue = newLocation.latitue
                location.logitude = newLocation.logitude
                location.placeName = newLocation.placeName
            }
        }
    }
}
