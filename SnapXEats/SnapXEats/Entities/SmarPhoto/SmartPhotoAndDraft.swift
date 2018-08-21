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
        if photo.smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
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
    }
    
    static func createDraftData(photo: DraftData, aminities: [String], predicate: NSPredicate) {
        if photo.smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            DispatchQueue.global(qos: .background).async {
                if  let data = DraftData.getDraftData(predicate: predicate)  {
                    updateDraftData(draftData: data, newData: photo)
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
    }
    
    static func updateDraftData(draftData: DraftData, newData: DraftData) {
         let realm = try! Realm()
        try! realm.write {
            draftData.audioURL = newData.audioURL
            draftData.textReview = newData.textReview
            draftData.rating = newData.rating
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
    
    static func alreadyStoredPhoto(smartPhotoID: String) -> Bool {
        return SmartPhotoData.checkSmartPhoto(smartPhotoID: smartPhotoID)
    }
    
    static func deleteDraftItem(smartPhoto_Draft_Stored_id: String) {
        DraftData.deleteDraft(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
    }
    
    static func hasSmartPhotos() -> Bool {
        return SmartPhotoData.count() > 0 ? true : false
    }
    
    static func hasDraftPhotos() -> Bool {
        return DraftData.count() > 0 ? true : false
    }
}

class SnapXPhotoData: Object {
    @objc dynamic var smartPhoto_Draft_Stored_id: String?
    @objc dynamic var restaurantName = SnapXEatsConstant.emptyString
    @objc dynamic var imageURL = SnapXEatsConstant.emptyString
    @objc dynamic var audioURL = SnapXEatsConstant.emptyString
    @objc dynamic var textReview = SnapXEatsConstant.emptyString
    @objc dynamic var rating = 3
    let restaurant_aminities =  List<String>()
    
}

class SmartPhotoData: SnapXPhotoData {
    @objc dynamic var smartPhotoID: String?
    
    static func getSmarPhotoData(predicate: NSPredicate) -> SmartPhotoData?  {
        var result: Results<SmartPhotoData>?
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        result = realm.objects(SmartPhotoData.self).filter(predicate)
        return result?.first
        
    }
    
    static func smartPhotos() -> Results<SmartPhotoData>?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        return realm.objects(SmartPhotoData.self)
    }
    
    static func checkSmartPhoto(smartPhotoID: String) -> Bool {
        let predicate  =  NSPredicate(format: "smartPhotoID == %@", smartPhotoID)
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result: Results<SmartPhotoData> = realm.objects(SmartPhotoData.self).filter(predicate)
        if let photoID = result.first?.smartPhotoID, photoID == smartPhotoID {
            return true
        }
        return false
    }
    
    static func count() -> Int {
        return smartPhotos()?.count ?? 0
    }
}

class DraftData: SnapXPhotoData {
    @objc dynamic var restaurantID: String?
    static func getDraftData(predicate: NSPredicate) -> DraftData?  {
        var result: Results<DraftData>?
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        result = realm.objects(DraftData.self).filter(predicate)
        return result?.first
    }
    
    static func drafts() -> Results<DraftData>?  {
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        return  realm.objects(DraftData.self)
    }
    
    static func count() -> Int {
        return drafts()?.count ?? 0
    }
    
    static func deleteDraft(smartPhoto_Draft_Stored_id: String) {
        let predicate  =  NSPredicate(format: "smartPhoto_Draft_Stored_id == %@", smartPhoto_Draft_Stored_id)
        // Get the default Realm
        let realm = try! Realm()
        // Query Realm for profile for which id is not empty
        let result: Results<DraftData> = realm.objects(DraftData.self).filter(predicate)
        
        if let item = result.first {
            try! realm.write {
                realm.delete(item)
            }
        }
    }
}
