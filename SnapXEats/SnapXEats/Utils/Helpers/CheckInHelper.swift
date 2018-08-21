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
    var checkInRestaurant: CheckInRestaurant?
    
    var userID : String {
        return  LoginUserPreferences.shared.isLoggedIn
                ? LoginUserPreferences.shared.loginUserID
                : SnapXNonLoggedInUserConstants.snapX_nonLogedIn_CheckIn
        
    }
    
    private init() {}
    
    func nonLoggedInUserCheckIn(checkIn: CheckInModel) {
        let predicate = NSPredicate(format: "userID == %@", SnapXNonLoggedInUserConstants.snapX_nonLogedIn_CheckIn)
             CheckInStore.createCheckInData(checkIn: mapCheckInStore(checkIn: checkIn), predicate: predicate)
    }
    
    func updateNonLoggedInToLoggedInCheckIn() {
        if userID != SnapXEatsConstant.emptyString {
            let predicate  =  NSPredicate(format: "userID == %@", SnapXNonLoggedInUserConstants.snapX_nonLogedIn_CheckIn)
            CheckInStore.updateCheckInID(loginID: userID, predicate: predicate)
        }
    }

    func checkInUser(checkIn: CheckInModel) {
        if let userID = checkIn.userID {
            let predicate  =  NSPredicate(format: "userID == %@", userID)
            CheckInStore.createCheckInData(checkIn: mapCheckInStore(checkIn: checkIn), predicate: predicate)
        }
    }
    
    func getCheckInRestroInfo() -> String? {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        if let user = CheckInStore.getCheckInStatus(predicate: predicate) {
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
        if let _ = CheckInStore.getCheckInStatus(predicate: predicate) {
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
    
    func userCheckedOut() {
        let predicate  =  NSPredicate(format: "userID == %@", userID)
        DispatchQueue.global(qos: .background).async {[weak self] in
            if let user = CheckInStore.getCheckInStatus(predicate: predicate), let checkInTime = user.checkIntime,
                let time = TimeInterval.init(checkInTime) {
                let timeInterval = Date().timeIntervalSince1970
                if (timeInterval - time ) >= CheckOutContant.timeInterval { //2 hour for auto checkout
                    self?.checkOutUser()
                }
            }
        }
    }
}
