//
//  FileManager.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

enum fileManagerConstants {
    static let nonLoggedInUserFolderName = "NonLoggedInUsers"
    static let audioReviewsFolderName = "Audio_Reviews"
    static let audioReviewFileNAme = "review.m4a"
    static let smartPhotosFolderName = "Smart_Photos"
    static let smartPhotoFileName = "photo.jpg"
}

func getPathForAudioReviewForRestaurant(restaurantId: String = "test_restaurant") -> URL? {
    
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    
    let userId = LoginUserPreferences.shared.isLoggedIn ? LoginUserPreferences.shared.loginUserID : fileManagerConstants.nonLoggedInUserFolderName

    let audioReviewsFolderName = fileManagerConstants.audioReviewsFolderName
    let pathComponent = userId + "/" + restaurantId + "/" + audioReviewsFolderName
    let audioRecordingPath = documentDirectory.appendingPathComponent(pathComponent)
    
    do {
        try fileManager.createDirectory(at: audioRecordingPath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("File Error --- \(error.localizedDescription)")
    }
    return audioRecordingPath?.appendingPathComponent(fileManagerConstants.audioReviewFileNAme)
}

func getPathForSmartPhotoForRestaurant(restaurantId: String) -> URL? {
    
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    
    let userId = LoginUserPreferences.shared.isLoggedIn ? LoginUserPreferences.shared.loginUserID : fileManagerConstants.nonLoggedInUserFolderName
    
    let smartPhotosFolderName = fileManagerConstants.smartPhotosFolderName
    let pathComponent = userId + "/" + restaurantId + "/" + smartPhotosFolderName
    let audioRecordingPath = documentDirectory.appendingPathComponent(pathComponent)
    
    do {
        try fileManager.createDirectory(at: audioRecordingPath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("File Error --- \(error.localizedDescription)")
    }
    return audioRecordingPath?.appendingPathComponent(fileManagerConstants.smartPhotoFileName)
}

func deleteAudioReview(restaurantId: String) {
    // Delete the Audio Recording from documents directory as well
    if let audioRecordingURL = getPathForAudioReviewForRestaurant(restaurantId: restaurantId) {
        do {
            try FileManager.default.removeItem(at: audioRecordingURL)
        } catch {
            print("Unable to Delete File")
        }
    }
}

func deletesmartPhoto(restaurantId: String) {
    // Delete the Smart Photo from documents directory as well
    if let smartPhotoURL = getPathForSmartPhotoForRestaurant(restaurantId: restaurantId) {
        do {
            try FileManager.default.removeItem(at: smartPhotoURL)
        } catch {
            print("Unable to Delete File")
        }
    }
}

func deleteUserReviewData(restaurantId: String) {
    deletesmartPhoto(restaurantId: restaurantId)
    deleteAudioReview(restaurantId: restaurantId)
}
