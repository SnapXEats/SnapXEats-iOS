//
//  CheckInHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 27/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class CheckInHelper {
    
    static let shared = CheckInHelper()
    let userID = LoginUserPreferences.shared.loginUserID
    private init() {}
    
    
    func checkInUser(checkIn: CheckInModel) {
        if let userID = checkIn.userID {
            let predicate  =  NSPredicate(format: "userID == %@", userID)
            CheckInStore.createCheckInData(checkIn: mapCheckInStore(checkIn: checkIn), predicate: predicate)
        }
    }
    
    func getCheckInRestroInfo() -> String? {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        if let user = CheckInStore.getCheckInStatus(predicate: predicate), user.userID == userID {
            return user.restaurantID
        }
        return nil
    }
    
    func checkOutUser() {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        CheckInStore.checkOutUser(predicate: predicate)
    }
    
    func isCheckedIn() -> Bool {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        if let user = CheckInStore.getCheckInStatus(predicate: predicate), user.userID == userID {
            return true
        }
        return false
    }
    
    func mapCheckInStore (checkIn: CheckInModel) -> CheckInStore {
        let checkInStore = CheckInStore()
        checkInStore.userID = checkIn.userID
        checkInStore.restaurantID = checkIn.restaurantID
        checkInStore.checkIntime = checkIn.checkIntime
        return checkInStore
    }
    
    func shouldCheckOut() {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        if let user = CheckInStore.getCheckInStatus(predicate: predicate), user.userID == userID, let checkInTime = user.checkIntime {
            let timeInterval = Date().timeIntervalSince1970
            if  let time = TimeInterval.init(checkInTime) {
                if (timeInterval - time ) >= 120  { //2 hour for auto checkout 
                    checkOutUser()
                }
            }
        }
    }
}
