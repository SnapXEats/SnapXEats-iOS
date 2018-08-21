//
//  FoodJourneyPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class FoodJourneyPresenter {

    // MARK: Properties

    var baseView: BaseView?
    var router: FoodJourneyWireframe?
    var interactor: FoodJourneyUseCase?
    
    private init() {}
    static let shared = FoodJourneyPresenter()
}

extension FoodJourneyPresenter: FoodJourneyPresentation {
    func getFoodJourneyData() {
        interactor?.sendFoodJourneyRequest()
    }
    
    func navigateToHomeScreen() {
        router?.presentScreen(screen: .location)
    }
}

extension FoodJourneyPresenter: FoodJourneyInteractorOutput {
    // TODO: implement interactor output methods
}
