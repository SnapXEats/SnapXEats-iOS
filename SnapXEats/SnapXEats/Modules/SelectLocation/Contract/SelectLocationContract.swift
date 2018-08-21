//
//  SelectLocationContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

protocol SelectLocationView: BaseView {
    var presenter: SelectLocationPresentation? {get set}
}

protocol SelectLocationPresentation: class {
    func getSearchPlaces(searchText: String)
    func getPlaceDetails(placeid: String)
    func storeLocation(location: LocationModel)
}

protocol SelectLocationInteractorOutput: Response {
}

protocol SelectLocationWireframe: RootWireFrame {
}

protocol SearchPlacePredictionsRequestFomatter: class {
    func getSearchPlacePredictionsFor(searchText: String)
    func getPlaceDetailsFor(placeid: String)
    func storeLocation(location: LocationModel)
}

protocol SearchPlacePredictionsWebService: class {
    func getSearchPlacePredictionRequest(forPath: String, withParameters parameters: [String: String])
    func getPlaceDetailsRequest(forPath: String, withParameters parameters: [String: String])
}

protocol SearchPlacePredictionsObjectMapper: class {
    func searchedPlacePredictionDetails(data: Result<SearchPlacePredictions> )
    func mapPlaceDetails(data: Result<SnapXEatsPlaceDetails> )
}

