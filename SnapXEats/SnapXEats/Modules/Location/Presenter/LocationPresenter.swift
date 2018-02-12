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
    
    // TODO: implement presentation methodsiewController
    func closeLocationView(selectedPreference: SelectedPreference, parent: UINavigationController) {
        router?.presentScreen(screen: .foodcards(selectPreference: selectedPreference, parentController: parent))
    }
    
    func selectLocation() {
        router?.presentScreen(screen: .selectLocation)
    }
    
    func cuisinePreferenceRequest(selectedPreference: SelectedPreference) {
        interactor?.getCuisines(selectedPreference: selectedPreference)
    }
}

extension LocationPresenter: LocationInteractorOutput {
    // TODO: implement interactor output methods
}

