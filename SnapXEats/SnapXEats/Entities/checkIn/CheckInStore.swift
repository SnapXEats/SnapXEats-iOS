//
//  CheckInStore.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 27/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class CheckInStore: Object {
    @objc dynamic var userID: String?
    @objc dynamic var restaurantID: String?
    @objc dynamic var checkIntime: String?
    
    
    static func createCheckInData(checkIn: CheckInStore, predicate: NSPredicate) {
        if let _ = checkIn.userID,
            checkIn.userID != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
                if  let _ = CheckInStore.getCheckInStatus(predicate: predicate)  {
                    updateStatus(newCheckIn: checkIn, predicate: predicate)
                }
                let realm = try! Realm()
                // Persist your data easily
                try! realm.write {
                    realm.add(checkIn)
                }
            }
        }
    }
    
    static func updateCheckInID(loginID: String, predicate: NSPredicate) {
        let realm = try! Realm()
        if let checkIn = getCheckInStatus(predicate: predicate) {
            try! realm.write {
                checkIn.userID = loginID
            }
        }
    }
    
    static func checkOutUser(predicate: NSPredicate) {
        DispatchQueue.global(qos: .background).async {
            if let checkIn = getCheckInStatus(predicate: predicate) {
                // Get the default Realm
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(checkIn)
                }
            }
        }
    }
    
    
    static func getCheckInStatus(predicate: NSPredicate) -> CheckInStore?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result = realm.objects(CheckInStore.self).filter(predicate)
        return result.first
        
    }
    
    static func updateStatus(newCheckIn: CheckInStore, predicate: NSPredicate) {
        let realm = try! Realm()
        if let checkIn = getCheckInStatus(predicate: predicate) {
            try! realm.write {
                checkIn.userID = newCheckIn.userID
                checkIn.restaurantID = newCheckIn.restaurantID
                checkIn.checkIntime = newCheckIn.checkIntime
            }
        }
    }
}
