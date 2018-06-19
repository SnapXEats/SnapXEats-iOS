//
//  RestaurantsMapViewInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 06/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class RestaurantsMapViewInteractor {

    // MARK: Properties

    weak var output: RestaurantsMapViewInteractorOutput?
}

extension RestaurantsMapViewInteractor: RestaurantsMapViewUseCase {
    func getUserPreference(userID: String) -> SetUserPreference? {
        return  PreferenceHelper.shared.getUserPrefernce(userID: userID)
    }
}
