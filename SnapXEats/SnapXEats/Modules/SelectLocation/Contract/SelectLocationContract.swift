//
//  SelectLocationContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

protocol SelectLocationView: class, BaseView {
    var presenter: SelectLocationPresentation? {get set}
    func initView()
}

protocol SelectLocationPresentation: class {
    func dismissScreen()
    func getSearchPlaces(searchText: String)
}

protocol SelectLocationUseCase: class {
    // TODO: Declare use case methods
}

protocol SelectLocationInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol SelectLocationWireframe: class, RootWireFrame {
}

protocol SearchPlacePredictionsRequestFomatter: class {
    func getSearchPlacePredictionsFor(searchText: String)
}

protocol SearchPlacePredictionsWebService: class {
    func getSearchPlacePredictionRequest(forPath: String, withParameters parameters: [String: String])
}

protocol SearchPlacePredictionsObjectMapper: class {
    func searchedPlacePredictionDetails(data: Result<SearchPlacePredictions> )
}

