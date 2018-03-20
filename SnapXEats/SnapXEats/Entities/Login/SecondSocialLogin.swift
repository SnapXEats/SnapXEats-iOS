//
//  SecondSocialLogin.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class SecondSocialLogin: Object {
    
    @objc dynamic var firstSocialId = SnapXEatsConstant.emptyString
    @objc dynamic var firstSocialToken = SnapXEatsConstant.emptyString
    @objc dynamic var firstSocialPlatForm = SnapXEatsConstant.emptyString
    
    @objc dynamic var secondSocialId = SnapXEatsConstant.emptyString
    @objc dynamic var secondSocialToken = SnapXEatsConstant.emptyString
    @objc dynamic var secondSocialPlatForm = SnapXEatsConstant.emptyString

    @objc dynamic var expireDateFBToken = Date()
    @objc dynamic var authenticateSharingFB = false
    @objc dynamic var authenticateSharingInstagram = false
    
    static func createSocialLogin(login: SecondSocialLogin, predicate: NSPredicate) {
        if login.firstSocialId != SnapXEatsConstant.emptyString {
            if  let _ = getSocialLogin(predicate: predicate)  {
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(login)
            }
        }
    }
    
    static func updateSecondSocialLogin(login: SecondSocialLogin, predicate: NSPredicate) {
        if login.firstSocialId != SnapXEatsConstant.emptyString {
            if  let _ = getSocialLogin(predicate: predicate)  {
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(login)
            }
        }
    }
    
    static func getFBAuthentication(userID: String) -> Bool {
        let predicate  =  NSPredicate(format: "firstSocialId == %@", userID)
        guard  let firstLogin = getSocialLogin(predicate: predicate) else {
            let predicate  =  NSPredicate(format: "secondSocialId == %@", userID)
            if  let secondLogin = getSocialLogin(predicate: predicate)  {
                return secondLogin.authenticateSharingFB
            }
            return false
        }
        return firstLogin.authenticateSharingFB
    }
    static func getSocialLogin(predicate: NSPredicate) -> SecondSocialLogin?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result: Results<SecondSocialLogin> = realm.objects(SecondSocialLogin.self).filter(predicate)
        return result.first
    }
    
}
