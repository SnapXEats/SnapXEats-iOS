//
//  LocationPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LocationPresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: LocationWireframe?
    var interactor: LocationRequestFomatter?
    
    private init() {}
    static let singleInstance = LocationPresenter()
}

extension LocationPresenter: LocationPresentation {
    func storeLocation(location: LocationModel) {
         interactor?.storeLocation(location: location)
    }
    
    func getLocation(userID: String) -> LocationModel? {
       return  interactor?.getLocation(userID: userID)
    }
    
    func updatedDrawerState(state: KYDrawerController.DrawerState) {
        router?.updatedDrawerState(state: state)
    }
    
    
    // TODO: implement presentation methodsiewController
    func closeLocationView(selectedPreference: SelectedPreference, parent: UINavigationController) {
        router?.presentScreen(screen: .foodcards(selectPreference: selectedPreference, parentController: parent))
    }
    
    func selectLocation(parent: UIViewController) {
        router?.presentScreen(screen: .selectLocation(parent: parent))
    }
    
    func cuisinePreferenceRequest(selectedPreference: SelectedPreference) {
        interactor?.getCuisines(selectedPreference: selectedPreference)
    }
}

extension LocationPresenter: LocationInteractorOutput {
    // TODO: implement interactor output methods
}

