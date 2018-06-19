//
//  RestaurantsMapViewPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantsMapViewPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: RestaurantsMapViewView?
    var router: RestaurantsMapViewWireframe?
    var interactor: RestaurantsMapViewUseCase?
}

extension RestaurantsMapViewPresenter: RestaurantsMapViewPresentation {
    func getUserPreference(userID: String) -> SetUserPreference? {
        return interactor?.getUserPreference(userID: userID)
    }
    
    func gotoRestaurantInfo(selectedRestaurant: String, parent: UINavigationController, showMoreInfo: Bool) {
        router?.presentScreen(screen: .restaurantDetails(restaurantID: selectedRestaurant, parentController: parent, showMoreInfo: showMoreInfo))
    }
}

extension RestaurantsMapViewPresenter: RestaurantsMapViewInteractorOutput {
    // TODO: implement interactor output methods
}
