//
//  LocationContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire
protocol LocationView: BaseView {
    var presenter: LocationPresentation? {get set}
    func initView()
}

protocol LocationPresentation: class {

        func closeLocationView(selectedPreference: SelectedPreference)
        func selectLocation()
        func cuisinePreferenceRequest()
}

protocol LocationRequestFomatter: class {
    func getCuisines()
}

protocol LocationWebService: class {
    func getCuisinesRequest(forPath: String)
}

protocol LocationObjectMapper: class {
    func cuisinesDetails(data: Result<CuisinePreference> )
}

protocol LocationInteractorOutput: Response {
}

protocol LocationWireframe: class, RootWireFrame {
    func loadLocationModule() -> LocationView
}
