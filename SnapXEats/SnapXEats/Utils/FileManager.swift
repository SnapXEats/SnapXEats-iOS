//
//  FileManager.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

func getPathForAudioReviewForRestaurant(restaurantId: String = "test_restaurant") -> URL? {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = urls[0] as NSURL
    
    let userId = LoginUserPreferences.shared.isLoggedIn ? LoginUserPreferences.shared.loginUserID : "NonLoggedInUsers"

    let audioReviewsFolderName = "Audio_Reviews"
    let pathComponent = userId + "/" + restaurantId + "/" + audioReviewsFolderName
    let audioRecordingPath = documentDirectory.appendingPathComponent(pathComponent)
    
    do {
        try fileManager.createDirectory(at: audioRecordingPath!, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Fiel Error --- \(error.localizedDescription)")
    }
    return audioRecordingPath?.appendingPathComponent("review.m4a")
}
