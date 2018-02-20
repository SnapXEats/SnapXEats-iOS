//
//  RestaurantDetailsInteractor.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import Alamofire

class RestaurantDetailsInteractor {

    // MARK: Properties

    var output: RestaurantDetailsInteractorOutput?
}

extension RestaurantDetailsInteractor: RestaurantDetailsRequestFormatter {
    func getRestaurantDetailsRequest(restaurant_id: String) {
        let path = SnapXEatsWebServicePath.restaurantDetails + "/" + restaurant_id
        getRestaurantDetails(forPath: path)
    }
}

extension RestaurantDetailsInteractor: RestaurantDetailsWebService {
    func getRestaurantDetails(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<RestaurantDetailsItem>) in
                let restaurantDetails = response.result
                self?.restaurantDetails(data: restaurantDetails)
        }
    }
}

extension RestaurantDetailsInteractor: RestaurantDetailsObjectMapper {

    func restaurantDetails(data: Result<RestaurantDetailsItem>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}


extension RestaurantDetailsInteractor: RestaurantDetailsUseCase {
    // TODO: Implement use case methods
}
