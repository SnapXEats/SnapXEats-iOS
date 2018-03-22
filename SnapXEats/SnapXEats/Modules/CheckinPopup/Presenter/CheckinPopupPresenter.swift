//
//  CheckinPopupPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class CheckinPopupPresenter {

    // MARK: Properties
    var baseView: BaseView?
    var router: CheckinPopupWireframe?
    var interactor: CheckinPopupRequestFormatter?
    
    static let shared = CheckinPopupPresenter()
    private init() {}
}

extension CheckinPopupPresenter: CheckinPopupPresentation {
    func checkinIntoRestaurant(restaurantId: String) {
        interactor?.checkinIntoRestaurantRequest(restaurant_id: restaurantId)
    }
}

extension CheckinPopupPresenter: CheckinPopupInteractorOutput {
    // TODO: implement interactor output methods
}
