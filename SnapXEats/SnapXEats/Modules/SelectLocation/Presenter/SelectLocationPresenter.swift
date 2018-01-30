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

    weak var view: SelectLocationView?
    var router: SelectLocationWireframe?
    var interactor: SearchPlacePredictionsRequestFomatter?
    
    private init() {}
    
    static let singleInstance = SelectLocationPresenter()
}

extension SelectLocationPresenter: SelectLocationPresentation {
    func dismissScreen() {
        router?.presentScreen(screen: .dismissNewLocation)
    }
    
    func getSearchPlaces(searchText: String) {
        interactor?.getSearchPlacePredictionsFor(searchText: searchText)
    }
}

extension SelectLocationPresenter: SelectLocationInteractorOutput {
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
    
    
}
