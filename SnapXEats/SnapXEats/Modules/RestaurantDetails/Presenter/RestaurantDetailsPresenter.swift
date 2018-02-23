//
//  RestaurantDetailsPresenter.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation

class RestaurantDetailsPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: RestaurantDetailsView?
    var router: RestaurantDetailsWireframe?
    var interactor: RestaurantDetailsRequestFormatter?
}

extension RestaurantDetailsPresenter: RestaurantDetailsPresentation {
    func restaurantDetailsRequest(restaurantId: String) {
        interactor?.getRestaurantDetailsRequest(restaurant_id: restaurantId)
    }
    
    func drivingDirectionsRequest(origin: String, destination: String) {
        interactor?.getDrivingDirectionsFor(origin: origin, destination: destination)
    }
}

extension RestaurantDetailsPresenter: RestaurantDetailsInteractorOutput {
    // TODO: implement interactor output methods
}
