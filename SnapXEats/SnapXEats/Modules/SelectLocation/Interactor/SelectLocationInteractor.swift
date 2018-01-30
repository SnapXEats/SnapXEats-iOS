//
//  SelectLocationInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class SelectLocationInteractor {

    // MARK: Properties

    var output: SelectLocationInteractorOutput?
    
    private init() {}
    
    static let singleInstance = SelectLocationInteractor()
}

extension SelectLocationInteractor: SelectLocationUseCase {
    // TODO: Implement use case methods
}

extension SelectLocationInteractor: SearchPlacePredictionsRequestFomatter {
    
    /**
     Prepare request URL to get Cuisnes.
     - parameters:
     - returns: Void
     */
    func getSearchPlacePredictionsFor(searchText: String) {
        let requestParameters = [
            SnapXEatsPlaceSearchRequestKeys.input: searchText,
            SnapXEatsPlaceSearchRequestKeys.components:SnapXEatsPlaceSearchConstants.components,
            SnapXEatsPlaceSearchRequestKeys.key: SnapXEatsPlaceSearchConstants.apiKey
        ]
        getSearchPlacePredictionRequest(forPath: SnapXEatsPlaceSearchConstants.apiUrl, withParameters: requestParameters)
    }
}

extension SelectLocationInteractor: SearchPlacePredictionsWebService {
    // TODO: Implement use case methods
    func getSearchPlacePredictionRequest(forPath: String, withParameters parameters: [String: String]) {
        SnapXEatsApi.snapXRequestWithParameters(path: forPath, parameters: parameters) { [weak self](response: DataResponse<SearchPlacePredictions>) in
            let placePredictionResult = response.result
            self?.searchedPlacePredictionDetails(data: placePredictionResult)
        }
    }
}

extension SelectLocationInteractor: SearchPlacePredictionsObjectMapper {
    // TODO: Implement use case methods
    func searchedPlacePredictionDetails(data: Result<SearchPlacePredictions> ) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _): break
            output?.response(result: NetworkResult.noInternet)
        }
    }
}
