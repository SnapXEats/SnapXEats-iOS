//
//  SmartPhotoAndDraft.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 16/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import RealmSwift

class SmartPhotoAndDraft: Object {
    
    static func createSmartPhotoData(photo: SmartPhotoData, aminities: [String], predicate: NSPredicate) {
        if photo.timeInterval != SnapXEatsConstant.emptyString {
            if  let _ = SmartPhotoData.getSmarPhotoData(predicate: predicate)  {
                return
            }
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                for aminity in aminities {
                    photo.restaurant_aminities.append(aminity)
                }
                realm.add(photo)
            }
        }
    }
    
    static func createDraftData(photo: DraftData, aminities: [String], predicate: NSPredicate) {
        if photo.timeInterval != SnapXEatsConstant.emptyString {
            if  let _ = DraftData.getDraftData(predicate: predicate)  {
                return
            }
            let realm = try! Realm()
            
            // Persist your data easily
            try! realm.write {
                for aminity in aminities {
                    photo.restaurant_aminities.append(aminity)
                }
                realm.add(photo)
            }
        }
    }
    
    static func getPhotos() -> Results<SmartPhotoData>? {
        return SmartPhotoData.smartPhotos()
    }
    
    static func getDrafts() -> Results<DraftData>? {
        return DraftData.drafts()
    }
    
    static func getSmartPhoto(predicate: NSPredicate) -> SmartPhotoData? {
        return SmartPhotoData.getSmarPhotoData(predicate: predicate)
    }
    
    static func getDraftPhoto(predicate: NSPredicate) -> DraftData? {
        return DraftData.getDraftData(predicate: predicate)
    }
}

class SnapXPhotoData: Object {
    @objc dynamic var timeInterval = SnapXEatsConstant.emptyString
    @objc dynamic var restaurantName = SnapXEatsConstant.emptyString
    @objc dynamic var imageURL = SnapXEatsConstant.emptyString
    @objc dynamic var audioURL = SnapXEatsConstant.emptyString
    @objc dynamic var textReview = SnapXEatsConstant.emptyString
    @objc dynamic var rating = 3
    let restaurant_aminities =  List<String>()
    
}

class SmartPhotoData: SnapXPhotoData {
     @objc dynamic var smartPhotoID = SnapXEatsConstant.emptyString
    
    static func getSmarPhotoData(predicate: NSPredicate) -> SmartPhotoData?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result: Results<SmartPhotoData> = realm.objects(SmartPhotoData.self).filter(predicate)
        return result.first
    }
    
    static func smartPhotos() -> Results<SmartPhotoData>?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        return realm.objects(SmartPhotoData.self)
    }
}

class DraftData: SnapXPhotoData {
     @objc dynamic var restaurantID = SnapXEatsConstant.emptyString
    static func getDraftData(predicate: NSPredicate) -> DraftData?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result: Results<DraftData> = realm.objects(DraftData.self).filter(predicate)
        return result.first
    }
    
    static func drafts() -> Results<DraftData>?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        return  realm.objects(DraftData.self)
    }
}
