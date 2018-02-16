//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class FBLogin: Object {
    
    @objc dynamic var Id = SnapXEatsConstant.emptyString
    @objc dynamic var name = SnapXEatsConstant.emptyString
    @objc dynamic var imageURL = SnapXEatsConstant.emptyString
    @objc dynamic var email = SnapXEatsConstant.emptyString
    @objc dynamic var serverUserID = SnapXEatsConstant.emptyString
    @objc dynamic var expireDate = Date()
    @objc dynamic var accessToken = SnapXEatsConstant.emptyString
    
    static  func createUserProfile(fbLogin: FBLogin) {
        // Get the default Realm
        if fbLogin.Id != SnapXEatsConstant.emptyString {
            if  let _ = getUserProfile(id: fbLogin.Id)  {
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(fbLogin)
            }
        }
    }
    
    static func getUserProfile(id: String) -> FBLogin?  {
        // Get the default Realm
        let realm = try! Realm()
        let predicate  =  NSPredicate(format: "Id == %@", id)
        // Query Realm for profile for which id is not empty
        let result: Results<FBLogin> = realm.objects(FBLogin.self).filter(predicate)
        return result.first
    }
    
    static func updateExpireDate(currentDate: Date, newDate: Date) {
        // Get the default Realm
        let realm = try! Realm()
       // let predicate  =  NSPredicate(format: "expireDate == %@", currentDate as CVarArg)
        let result: Results<FBLogin> = realm.objects(FBLogin.self).filter("expireDate == '\(currentDate)'")
        if let fbLogin = result.first {
            try! realm.write {
                fbLogin.expireDate = newDate
            }
        }
    }
}

