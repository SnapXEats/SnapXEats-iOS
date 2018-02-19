//
//  RestaurantDetailsPresenter.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation

class RestaurantDetailsPresenter {

    // MARK: Properties

    weak var view: RestaurantDetailsView?
    var router: RestaurantDetailsWireframe?
    var interactor: RestaurantDetailsUseCase?
}

extension RestaurantDetailsPresenter: RestaurantDetailsPresentation {
    // TODO: implement presentation methods
}

extension RestaurantDetailsPresenter: RestaurantDetailsInteractorOutput {
    // TODO: implement interactor output methods
}
