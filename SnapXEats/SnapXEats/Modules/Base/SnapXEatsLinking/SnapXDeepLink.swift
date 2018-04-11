//
//  SnapXDeepLink.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation


/// Represents presenting an image to the user.
/// Example - snapXEats://dishes/photo?id=
struct SnapXEatsPhotoDeepLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term("dishes")
        .term("photo")
        .queryStringParameters([
            .requiredString(named: "id")
            ])
    
    init(values: DeepLinkValues) {
        imageName = values.query["id"] as! String
    }
    
    let imageName: String
}
