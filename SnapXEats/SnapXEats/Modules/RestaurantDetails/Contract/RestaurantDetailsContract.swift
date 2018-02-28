//
//  RestaurantDetailsContract.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import Alamofire

protocol RestaurantDetailsView: class, BaseView {
    // TODO: Declare view methods
}

protocol RestaurantDetailsPresentation: class {
    func restaurantDetailsRequest(restaurantId: String)
    func drivingDirectionsRequest(origin: String, destination: String)
    func gotoRestaurantDirections(restaurantDetails: RestaurantDetails, parent: UINavigationController)
}

protocol RestaurantDetailsUseCase: class {
    // TODO: Declare use case methods
}

protocol RestaurantDetailsInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol RestaurantDetailsWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}

protocol RestaurantDetailsRequestFormatter: class {
    func getRestaurantDetailsRequest(restaurant_id: String)
    func getDrivingDirectionsFor(origin: String, destination: String)
}

protocol RestaurantDetailsWebService: class {
    func getRestaurantDetails(forPath: String)
    func getDrivingDirectionsRequest(forPath: String)
}

protocol RestaurantDetailsObjectMapper: class {
    func restaurantDetails(data: Result<RestaurantDetailsItem>)
    func drivingDirectionDetails(data: Result<DrivingDirections>)
}
