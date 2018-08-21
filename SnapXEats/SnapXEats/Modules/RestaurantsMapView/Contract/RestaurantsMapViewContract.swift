//
//  RestaurantsMapViewContract.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol RestaurantsMapViewView: BaseView {
     var presenter: RestaurantsMapViewPresentation? {get set}
}

protocol RestaurantsMapViewPresentation: class {
    func gotoRestaurantInfo(selectedRestaurant: String, parent: UINavigationController, showMoreInfo: Bool)
    func getUserPreference(userID: String) -> SetUserPreference?
}

protocol RestaurantsMapViewUseCase: class {
     func getUserPreference(userID: String) -> SetUserPreference?
}

protocol RestaurantsMapViewInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol RestaurantsMapViewWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}
