//
//  LocationInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class LocationInteractor {

    // MARK: Properties

    var output: LocationInteractorOutput?
    private init() {}
    static let singleInstance = LocationInteractor()
}

extension LocationInteractor: LocationRequestFomatter {
    
    /**
     Prepare request URL to get Cuisnes.
     - parameters:
      - returns: Void
     */
    func getCuisines() {
        getCuisinesRequest(forPath: SnapXEatsWebServicePath.cuisinePreferenceURL)
    }
}

extension LocationInteractor: LocationWebService {
    // TODO: Implement use case methods
    func getCuisinesRequest(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath ) { [weak self] (response: DataResponse<CuisinePreference>) in
            guard let strongSelf = self else { return }
            let cuisePrefernceArray = response.result
            strongSelf.cuisinesDetails(data: cuisePrefernceArray)
        }
    }
}

extension LocationInteractor: LocationObjectMapper {
    
    // TODO: Implement use case methods
    func cuisinesDetails(data: Result<CuisinePreference> ) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
        output?.response(result: NetworkResult.noInternet)
        }
    }
}

