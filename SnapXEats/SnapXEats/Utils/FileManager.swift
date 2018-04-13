//
//  FileManager.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum fileManagerConstants {
    static let nonLoggedInUserFolderName = "NonLoggedInUsers"
    static let audioReviewsFolderName = "Audio_Reviews"
    static let audioReviewFileNAme = "review.m4a"
    static let smartPhotosFolderName = "Smart_Photos"
    static let smartPhotoFileName = "photo.jpg"
    static let rootFolder = "SnapXEats"
    static let draftFolder = "Draft"
    static let smartPhotoFolder = "SmartPhoto"
}

enum SmartPhotoPath {
    case smartPhoto(fileName: String), draft(fileName: String)
    
    func  getPath () -> URL? {
        switch self {
        case .smartPhoto(let fileName):
            return getPhoto(fileName: fileName,path: fileManagerConstants.smartPhotoFolder)
            
        case .draft(let fileName):
            return getPhoto(fileName: fileName, path: fileManagerConstants.draftFolder)
        }
    }
}

func getPhoto(fileName: String, path: String) -> URL? {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    
    let pathComponent = fileManagerConstants.rootFolder + "/" + path
    let smarPhotoFilePath = documentDirectory.appendingPathComponent(pathComponent)
    
    do {
        try fileManager.createDirectory(at: smarPhotoFilePath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("File Error --- \(error.localizedDescription)")
    }
    return smarPhotoFilePath?.appendingPathComponent(fileName)
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

func getPathForSmartPhotoForRestaurant(restaurantId: String, skipSharedLogin: Bool = false) -> URL? {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    
    var userId = LoginUserPreferences.shared.isLoggedIn ? LoginUserPreferences.shared.loginUserID : fileManagerConstants.nonLoggedInUserFolderName
    
    if skipSharedLogin == true {
        userId = fileManagerConstants.nonLoggedInUserFolderName
    }
    let smartPhotosFolderName = fileManagerConstants.smartPhotosFolderName
    let pathComponent = userId + "/" + restaurantId + "/" + smartPhotosFolderName
    let storedPhotoPath = documentDirectory.appendingPathComponent(pathComponent)
    
    do {
        try fileManager.createDirectory(at: storedPhotoPath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("File Error --- \(error.localizedDescription)")
    }
    return storedPhotoPath?.appendingPathComponent(fileManagerConstants.smartPhotoFileName)
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

func getFileName(filePath: String?) -> String? {
    if  let path = filePath, let url = URL(string: path) {
        return url.lastPathComponent
    }
    return nil
}

 func savePhoto(image: UIImage, path: URL) -> Bool {
        do {
            try UIImageJPEGRepresentation(image, 0.3)?.write(to: path, options: .atomic)
            return true
        } catch {
            print("file cant not be saved at path \(path), with error : \(error)")
        }
    return false
}

func saveAudioFile(value: Data, path: URL) -> Bool {
        do {
            try  value.write(to: path)
            return true
        }
        catch {
            print("file cant not be saved at path \(path), with error : \(error)")
        }
    return false
}
