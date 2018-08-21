//
//  SelectLocationPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SelectLocationPresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: SelectLocationWireframe?
    var interactor: SearchPlacePredictionsRequestFomatter?
    
    private init() {}
    
    static let singleInstance = SelectLocationPresenter()
}

extension SelectLocationPresenter: SelectLocationPresentation {
    func storeLocation(location: LocationModel) {
        interactor?.storeLocation(location: location)
    }
    
    
    func getSearchPlaces(searchText: String) {
        interactor?.getSearchPlacePredictionsFor(searchText: searchText)
    }
    
    func getPlaceDetails(placeid: String) {
        interactor?.getPlaceDetailsFor(placeid: placeid)
    }
}

extension SelectLocationPresenter: SelectLocationInteractorOutput {
}
