//
//  RestaurantsMapViewPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class RestaurantsMapViewPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: RestaurantsMapViewView?
    var router: RestaurantsMapViewWireframe?
    var interactor: RestaurantsMapViewUseCase?
}

extension RestaurantsMapViewPresenter: RestaurantsMapViewPresentation {
    // TODO: implement presentation methods
}

extension RestaurantsMapViewPresenter: RestaurantsMapViewInteractorOutput {
    // TODO: implement interactor output methods
}
