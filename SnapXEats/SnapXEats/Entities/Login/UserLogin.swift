//
//  UserLogin.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 17/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class UserLogin: Object {
    
    @objc dynamic var Id = SnapXEatsConstant.emptyString
    @objc dynamic var name = SnapXEatsConstant.emptyString
    @objc dynamic var imageURL = SnapXEatsConstant.emptyString
    @objc dynamic var email = SnapXEatsConstant.emptyString
    @objc dynamic var serverUserID = SnapXEatsConstant.emptyString
    @objc dynamic var serverUserToken = SnapXEatsConstant.emptyString
    
    @objc dynamic var expireDate = Date()
    @objc dynamic var accessToken = SnapXEatsConstant.emptyString
    
    static func createUserProfile(login: UserLogin) {
        // Get the default Realm
        if login.Id != SnapXEatsConstant.emptyString {
            if  let _ = getUserProfile(id: login.Id)  {
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(login)
            }
        }
    }
    
    static func getUserProfile(id: String) -> UserLogin?  {
        // Get the default Realm
        let realm = try! Realm()
        let predicate  =  NSPredicate(format: "Id == %@", id)
        // Query Realm for profile for which id is not empty
        let result: Results<UserLogin> = realm.objects(UserLogin.self).filter(predicate)
        return result.first
    }
    
    // Expire date is only for FB token
    static func updateExpireDate(currentDate: Date, newDate: Date) {
        // Get the default Realm
        let realm = try! Realm()
        // let predicate  =  NSPredicate(format: "expireDate == %@", currentDate as CVarArg)
        let result: Results<UserLogin> = realm.objects(UserLogin.self).filter("expireDate == '\(currentDate)'")
        if let userLogin = result.first {
            try! realm.write {
                userLogin.expireDate = newDate
            }
        }
    }

    static func deleteStoredLogedInUser() {
        // Get the default Realm
        let realm = try! Realm()
        // Delete all objects from the realm
        try! realm.write {
            realm.deleteAll()
        }
    }
}

