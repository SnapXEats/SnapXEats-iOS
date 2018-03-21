//
//  SnapNShareHomeInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class SnapNShareHomeInteractor {

    // MARK: Properties
    var output: SnapNShareHomeInteractorOutput?
    static let shared = SnapNShareHomeInteractor()
    private init() {}
}

extension SnapNShareHomeInteractor: SnapNShareHomeRequestFormatter {
    func getRestaurantDetailsRequest(restaurant_id: String) {
        let path = SnapXEatsWebServicePath.restaurantDetails + "/" + restaurant_id
        getRestaurantDetails(forPath: path)
    }
}

extension SnapNShareHomeInteractor: SnapNShareHomeWebService {
    func getRestaurantDetails(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<RestaurantDetailsItem>) in
            let restaurantDetails = response.result
            self?.restaurantDetails(data: restaurantDetails)
        }
    }
}

extension SnapNShareHomeInteractor: SnapNShareHomeObjectMapper {
    
    func restaurantDetails(data: Result<RestaurantDetailsItem>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}


