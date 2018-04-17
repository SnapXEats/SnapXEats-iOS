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
    static let audioReviewFileName = "SnapX_Draft_Audio.m4a"
    static let smartPhotosFolderName = "Smart_Photos"
    static let smartPhotoFileName = "SnapX_Draft_photo.jpg"
    static let rootFolder = "SnapXEats"
    static let draftFolder = "Draft"
    static let smartPhotoFolder = "SmartPhoto"
}

enum SmartPhotoPath {
    case smartPhoto(fileName: String, id: String), draft(fileName: String, id: String)
    
    func  getPath () -> URL? {
        switch self {
        case .smartPhoto(let fileName, let id ):
            return getFilePath(fileName: fileName,path: fileManagerConstants.smartPhotoFolder + "/\(id)")
            
        case .draft(let fileName, let id):
            return getFilePath(fileName: fileName, path: fileManagerConstants.draftFolder + "/\(id)")
        }
    }
}

func getFilePath(fileName: String, path: String) -> URL? {
    var timeInterval = UserDefaults.standard.string(forKey: SnapXEatsConstant.timeInterval) ?? SnapXEatsConstant.emptyString
    if  timeInterval  == SnapXEatsConstant.emptyString {
        // You need  to reset the time interval before saving the new photo
        timeInterval = "\(Date().timeIntervalSince1970)"
        UserDefaults.standard.set(timeInterval, forKey: SnapXEatsConstant.timeInterval)
    }
    let pathComponent = fileManagerConstants.rootFolder + "/" + path + "/" + "\(timeInterval)"
   
    let filePath =  apptoDocumentDirPath(path: pathComponent)
    let fileManager = FileManager.default
    do {
        try fileManager.createDirectory(at: filePath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("File Error --- \(error.localizedDescription)")
    }
    
    return filePath?.appendingPathComponent(fileName)
}

func getPathTillDocDir(path: String) -> String? {
     let result = path.range(of: fileManagerConstants.rootFolder,
                                            options: NSString.CompareOptions.literal,
                                            range: path.startIndex..<path.endIndex,
                                            locale: nil)
   // https://www.dotnetperls.com/find-swift
    if let range = result {
        // Start of range of found string.
        let start = range.lowerBound
        return "\(path[start..<path.endIndex])"
    }
    return nil
}

func apptoDocumentDirPath(path: String) -> URL? {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    return documentDirectory.appendingPathComponent(path)
}

func deleteAudioReview(restaurantId: String) {
    // Delete the Audio Recording from documents directory as well
    if let audioRecordingURL = SmartPhotoPath.smartPhoto(fileName: fileManagerConstants.audioReviewFileName, id: restaurantId).getPath() {
        do {
            try FileManager.default.removeItem(at: audioRecordingURL)
        } catch {
            print("Unable to Delete File")
        }
    }
}

func deletesmartPhoto(restaurantId: String) {
    // Delete the Smart Photo from documents directory as well
    if let smartPhotoURL = SmartPhotoPath.smartPhoto(fileName: fileManagerConstants.smartPhotoFileName, id: restaurantId).getPath() {
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

func resetImageSaveTimeInterval() {
    UserDefaults.standard.set(SnapXEatsConstant.emptyString, forKey: SnapXEatsConstant.timeInterval)
}

func getTimeInterval() -> String {
     return UserDefaults.standard.string(forKey: SnapXEatsConstant.timeInterval) ?? SnapXEatsConstant.emptyString
}
