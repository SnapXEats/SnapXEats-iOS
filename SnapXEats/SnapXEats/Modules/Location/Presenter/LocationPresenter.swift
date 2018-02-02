//
//  LocationPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class LocationPresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: LocationWireframe?
    var interactor: LocationRequestFomatter?
    
    private init() {}
    static let singleInstance = LocationPresenter()
}

extension LocationPresenter: LocationPresentation {
    
    // TODO: implement presentation methods
    func closeLocationView(selectedPreference: SelectedPreference) {
        router?.presentScreen(screen: .foodcards(selectPreference: selectedPreference))
    }
    
    func selectLocation() {
        router?.presentScreen(screen: .selectLocation)
    }
    
    func cuisinePreferenceRequest() {
        interactor?.getCuisines()
    }
}

extension LocationPresenter: LocationInteractorOutput {
    // TODO: implement interactor output methods
}

