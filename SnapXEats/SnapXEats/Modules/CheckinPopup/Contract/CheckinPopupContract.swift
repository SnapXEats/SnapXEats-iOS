//
//  CheckinPopupContract.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

protocol CheckinPopupView: BaseView {
    
}

protocol CheckinPopupPresentation: class {
    func checkinIntoRestaurant(restaurantId: String)
}

protocol CheckinPopupUseCase: class {
    // TODO: Declare use case methods
}

protocol CheckinPopupInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol CheckinPopupWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol CheckinPopupRequestFormatter: class {
    func checkinIntoRestaurantRequest(restaurant_id: String)
    func getNearbyRestaurantRequest(latitude: String, longitude: String)
}

protocol CheckinPopupWebService: class {
    func checkinIntoRestaurant(forPath: String, withParameters: [String: Any])
    func getNearbyRestaurants(forPath: String, withParameters: [String: Any])
}

protocol CheckinPopupObjectMapper: class {
    func mapCheckinIntoRestaurantResult(data: Result<RewardPoints>)
    func mapRestaurantListResult(data: Result<RestaurantsList>)
}
