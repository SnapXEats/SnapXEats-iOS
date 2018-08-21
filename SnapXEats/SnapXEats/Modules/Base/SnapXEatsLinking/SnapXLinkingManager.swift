//
//  SnapXLinkingManager.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

//enum DeeplinkType {
//    enum Messages {
//        case root
//        case details(id: String)
//    }
//    
//    case smartPhoto
//    case snapNotification
//    case serverNotification
//}

class SnapXLinkingManager {
   
    private init() {}
    static let shared = SnapXLinkingManager()
   // private var deeplinkType: DeeplinkType?
   
    func checkDeepLink(with url: URL) -> Bool {
        // Create a recognizer with this app's custom deep link types.
        let recognizer = DeepLinkRecognizer(deepLinkTypes: [
            SnapXEatsPhotoDeepLink.self])
        
        // Try to create a deep link object based on the URL.
        guard let deepLink = recognizer.deepLink(matching: url) else {
            print("Unable to match URL: \(url.absoluteString)")
            return false
        }
        
        SnapXLinkNavigator.shared.proceedToDeeplink(deepLink)
        return true
    }
}
