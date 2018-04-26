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
}

protocol LocationPresentation: class {

    func closeLocationView(selectedPreference: SelectedPreference, parent: UINavigationController)
    func selectLocation(parent: UIViewController)
    func cuisinePreferenceRequest(selectedPreference: SelectedPreference)
    func updatedDrawerState(state: KYDrawerController.DrawerState)
    func storeLocation(location: LocationModel)
    func getLocation(userID:  String) -> LocationModel?
}

protocol LocationRequestFomatter: class {
    func getCuisines(selectedPreference: SelectedPreference)
    func storeLocation(location: LocationModel)
    func getLocation(userID:  String) -> LocationModel?
}

protocol LocationWebService: class {
    func getCuisinesRequest(forPath: String, withParameters: [String: Any])
}

protocol LocationObjectMapper: class {
    func cuisinesDetails(data: Result<CuisinePreference> )
}

protocol LocationInteractorOutput: Response {
}

protocol LocationWireframe: class, RootWireFrame {
    func loadLocationModule () -> UINavigationController
    func updatedDrawerState(state: KYDrawerController.DrawerState)
}
