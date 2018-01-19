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

    weak var view: LocationView?
    var router: LocationWireframe?
    var interactor: LocationUseCase?
    
    private init() {}
    static let singleInstance = LocationPresenter()
}

extension LocationPresenter: LocationPresentation {
    // TODO: implement presentation methods
    func closeLocationView() {
        router?.presentScreen(screen: .card)
    }
    
    func selectLocation() {
        router?.presentScreen(screen: .newLocation)
    }
}

extension LocationPresenter: LocationInteractorOutput {
    // TODO: implement interactor output methods
}
