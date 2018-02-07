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
    func getCuisines(selectedPreference: SelectedPreference) {
        let lat = selectedPreference.getLatitude()  // This is for testing we need to send actual from selectedpreferences
        let requestParameters: [String: Any] = [
            SnapXEatsWebServiceParameterKeys.latitude: lat.0,
            SnapXEatsWebServiceParameterKeys.longitude: lat.1,
            SnapXEatsWebServiceParameterKeys.authorization: ""
        ]
        getCuisinesRequest(forPath: SnapXEatsWebServicePath.cuisinePreferenceURL, withParameters: requestParameters)
    }
}

extension LocationInteractor: LocationWebService {
    // TODO: Implement use case methods
    func getCuisinesRequest(forPath: String, withParameters: [String: Any]) {
        
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self](response: DataResponse<CuisinePreference>) in
            let cuisePrefernceArray = response.result
            self?.cuisinesDetails(data: cuisePrefernceArray)
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

