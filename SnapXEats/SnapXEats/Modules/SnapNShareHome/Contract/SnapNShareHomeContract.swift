//
//  SnapNShareHomeContract.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol SnapNShareHomeView: class, BaseView {
    // TODO: Declare view methods
}

protocol SnapNShareHomePresentation: class {
    func gotoSnapNSharePhotoView(parent: UINavigationController, withPhoto photo: UIImage)
    func restaurantDetailsRequest(restaurantId: String)
}

protocol SnapNShareHomeUseCase: class {
    // TODO: Declare use case methods
}

protocol SnapNShareHomeInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol SnapNShareHomeWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol SnapNShareHomeRequestFormatter: class {
    func getRestaurantDetailsRequest(restaurant_id: String)
}

protocol SnapNShareHomeWebService: class {
    func getRestaurantDetails(forPath: String)
}

protocol SnapNShareHomeObjectMapper: class {
    func restaurantDetails(data: Result<RestaurantDetailsItem>)
}
