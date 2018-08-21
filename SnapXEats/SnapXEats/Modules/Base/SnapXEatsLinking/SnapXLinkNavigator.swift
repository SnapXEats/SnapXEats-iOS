//
//  DeepLinkNavigator.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SnapXLinkNavigator {
    static let shared = SnapXLinkNavigator()
    private init() { }
    
    func proceedToDeeplink(_ deepLink: DeepLink) {
        
        // Navigate to the view or content specified by the deep link.
        switch deepLink {
        //case let link as SelectTabDeepLink: return selectTab(with: link)
        case let link as SnapXEatsPhotoDeepLink:
            presentScreen(screens: .smartPhoto(smartPhoto_Draft_Stored_id: nil, dishID: link.imageName, type: .smartPhoto, parentController: nil))
        default: fatalError("Unsupported DeepLink: \(type(of: deepLink))")
        }
    }
    
    func presentScreen(screens: Screens) {
         RootRouter.shared.presentScreen(screens: screens)
    }
}
