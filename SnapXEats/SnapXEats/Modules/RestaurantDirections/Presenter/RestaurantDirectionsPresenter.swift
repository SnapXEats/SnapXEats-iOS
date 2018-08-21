//
//  RestaurantDirectionsPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 28/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class RestaurantDirectionsPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: RestaurantDirectionsView?
    var router: RestaurantDirectionsWireframe?
    var interactor: RestaurantDirectionsUseCase?
}

extension RestaurantDirectionsPresenter: RestaurantDirectionsPresentation {
    // TODO: implement presentation methods
}

extension RestaurantDirectionsPresenter: RestaurantDirectionsInteractorOutput {
    // TODO: implement interactor output methods
}
