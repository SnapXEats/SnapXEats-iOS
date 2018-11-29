//
//  SnapXDeepLink.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 09/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation


/// Represents presenting an image to the user.
//https://app.snapxeats.com/redirectPage/?link=https%3A%2F%2Fs3.us-east-2.amazonaws.com%2Ffiletoupload%2FzUP7YgYypLpFrspr2gLDUf6V.jpeg&fbclid=IwAR1LvMqOYHfzV55EOXsAenhxQAnN3D3Qp0fQqETWTH8q52Rq96NIiuPrXkA&id=20d19925-2be7-4875-88d5-5067d252c9e5
//https://app.snapxeats.com/api/v1/dishes/smartPhoto?url=snapxeats://dishes?id=20d19925-2be7-4875-88d5-5067d252c9e5
/// Example - snapxeats://dishes?id=
struct SnapXEatsPhotoDeepLink: DeepLink {
    static let template = DeepLinkTemplate()
        .queryStringParameters([
            .requiredString(named: "id")
            ])
    
    init(values: DeepLinkValues) {
        imageName = values.query["id"] as! String
    }
    
    let imageName: String
}
