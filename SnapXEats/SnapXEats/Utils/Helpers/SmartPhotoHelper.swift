//
//  SmartPhotoHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 16/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SmartPhotoHelper {
    
    static let shared  = SmartPhotoHelper()
    private init() {}
    
    func savePhotoDraft(smartPhoto: SmartPhoto) {
        if smartPhoto.smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            let draftData = mapDraftPhotosToData(smartPhoto: smartPhoto)
            if let id = draftData.smartPhoto_Draft_Stored_id {
            let predicate  =  NSPredicate(format: "smartPhoto_Draft_Stored_id == %@", id)
            SmartPhotoAndDraft.createDraftData(photo: draftData, aminities: smartPhoto.restaurant_aminities, predicate: predicate)
            }
        }
    }
    
    func getDraftPhoto(smartPhoto_Draft_Stored_id: String) -> SmartPhoto? {
        if smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            let predicate  =  NSPredicate(format: "smartPhoto_Draft_Stored_id == %@", smartPhoto_Draft_Stored_id)
            if let draftData = SmartPhotoAndDraft.getDraftPhoto(predicate: predicate) {
                return mapDataToDraftPhoto(draftData: draftData)
            }
        }
        return nil
    }
    
    func saveSmartPhoto(smartPhoto: SmartPhoto) {
        if smartPhoto.smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            let photoData = mapSmartPhotosToData(smartPhoto: smartPhoto)
             if let id = photoData.smartPhoto_Draft_Stored_id {
            let predicate  =  NSPredicate(format: "smartPhoto_Draft_Stored_id == %@", id)
            SmartPhotoAndDraft.createSmartPhotoData(photo: photoData, aminities: smartPhoto.restaurant_aminities, predicate: predicate)
            }
        }
    }
    
    func getSmartPhoto(smartPhoto_Draft_Stored_id: String) -> SmartPhoto?  {
        if smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            let predicate  =  NSPredicate(format: "smartPhoto_Draft_Stored_id == %@", smartPhoto_Draft_Stored_id)
            if  let smartPhotoData = SmartPhotoAndDraft.getSmartPhoto(predicate: predicate) {
                return  mapDataToSmartPhoto(photosData: smartPhotoData)
            }
        }
        return nil
    }
    
    func hasSmartPhoto(smartPhotoDishId: String) -> Bool {
        if smartPhotoDishId != SnapXEatsConstant.emptyString {
            return SmartPhotoAndDraft.alreadyStoredPhoto(smartPhotoID: smartPhotoDishId)
        }
        return false
    }
    
    func deleteDraftReview(smartPhoto_Draft_Stored_id: String) {
        SmartPhotoAndDraft.deleteDraftItem(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
    }
    
    private func mapSmartPhotosToData(smartPhoto: SmartPhoto) -> SmartPhotoData {
        let smartPhotoData = SmartPhotoData()
        smartPhotoData.smartPhotoID = smartPhoto.restaurant_item_id
        smartPhotoData.imageURL = smartPhoto.dish_image_url
        smartPhotoData.audioURL = smartPhoto.audio_review_url
        smartPhotoData.textReview = smartPhoto.text_review
        smartPhotoData.restaurantName = smartPhoto.restaurant_name
        smartPhotoData.rating = smartPhoto.rating
        smartPhotoData.smartPhoto_Draft_Stored_id = smartPhoto.smartPhoto_Draft_Stored_id
        return smartPhotoData
        
    }
    
    private func mapDraftPhotosToData(smartPhoto: SmartPhoto) -> DraftData {
        let draftPhotoData = DraftData()
        draftPhotoData.restaurantID = smartPhoto.restaurant_item_id
        draftPhotoData.imageURL = smartPhoto.dish_image_url
        draftPhotoData.audioURL = smartPhoto.audio_review_url
        draftPhotoData.textReview = smartPhoto.text_review
        draftPhotoData.restaurantName = smartPhoto.restaurant_name
        draftPhotoData.smartPhoto_Draft_Stored_id = smartPhoto.smartPhoto_Draft_Stored_id
        draftPhotoData.rating = smartPhoto.rating
        return draftPhotoData
        
    }
    
    func getSmartPhotos() -> [SmartPhoto] {
        var smartPhotos = [SmartPhoto]()
        if  let draftPhotos = SmartPhotoAndDraft.getPhotos() {
            for  photosData in draftPhotos {
                smartPhotos.append(mapDataToSmartPhoto(photosData: photosData))
            }
        }
        return smartPhotos
    }
    
    func getDraftPhotos() -> [SmartPhoto] {
        var smartPhotos = [SmartPhoto]()
        if  let draftPhotos = SmartPhotoAndDraft.getDrafts() {
            for  photosData in draftPhotos {
                smartPhotos.append(mapDataToDraftPhoto(draftData: photosData))
            }
        }
        return smartPhotos
    }
    
    func mapDataToSmartPhoto(photosData: SmartPhotoData) -> SmartPhoto {
        let photo = SmartPhoto()
        photo.restaurant_item_id = photosData.smartPhotoID
        photo.audio_review_url = photosData.audioURL
        photo.dish_image_url = photosData.imageURL
        photo.text_review = photosData.textReview
        photo.restaurant_name = photosData.restaurantName
        for  aminity in photosData.restaurant_aminities {
            photo.restaurant_aminities.append(aminity)
        }
        photo.smartPhoto_Draft_Stored_id = photosData.smartPhoto_Draft_Stored_id
        photo.rating = photosData.rating
        return photo
    }
    
    func mapDataToDraftPhoto(draftData: DraftData) -> SmartPhoto {
        let photo = SmartPhoto()
        photo.restaurant_item_id = draftData.restaurantID
        photo.audio_review_url = draftData.audioURL
        photo.dish_image_url = draftData.imageURL
        photo.text_review = draftData.textReview
        photo.restaurant_name = draftData.restaurantName
        for  aminity in draftData.restaurant_aminities {
            photo.restaurant_aminities.append(aminity)
        }
        photo.smartPhoto_Draft_Stored_id = draftData.smartPhoto_Draft_Stored_id
        photo.rating = draftData.rating
        return photo
    }
}
