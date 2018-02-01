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
    var interactor: LocationRequestFomatter?
    
    private init() {}
    static let singleInstance = LocationPresenter()
}

extension LocationPresenter: LocationPresentation {
    
    // TODO: implement presentation methods
    func closeLocationView() {
        router?.presentScreen(screen: .foodcards)
    }
    
    func selectLocation() {
        router?.presentScreen(screen: .selectLocation)
    }
    
    func cuisinePreferenceRequest() {
        interactor?.getCuisines()
    }
}

extension LocationPresenter: LocationInteractorOutput {
    func response(result: NetworkResult) {
        switch result {
        case .success(let value):
            view?.success(result: value)
        case .error:
            view?.error(result: .error)
        case .noInternet:
            view?.error(result: .noInternet)
        default: break
        }
    }
    
    // TODO: implement interactor output methods
}
