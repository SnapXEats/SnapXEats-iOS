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
}

protocol RestaurantDetailsUseCase: class {
    // TODO: Declare use case methods
}

protocol RestaurantDetailsInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol RestaurantDetailsWireframe: class {
    // TODO: Declare wireframe methods
}

protocol RestaurantDetailsRequestFormatter: class {
    func getRestaurantDetailsRequest(restaurant_id: String)
}

protocol RestaurantDetailsWebService: class {
    func getRestaurantDetails(forPath: String)
}

protocol RestaurantDetailsObjectMapper: class {
    func restaurantDetails(data: Result<RestaurantDetailsItem>)
}
