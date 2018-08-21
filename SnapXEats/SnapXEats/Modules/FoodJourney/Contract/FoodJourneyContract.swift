//
//  FoodJourneyContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire
protocol FoodJourneyView:  BaseView {
    var presenter: FoodJourneyPresentation? {get set}
}

protocol FoodJourneyPresentation: class {
    func getFoodJourneyData()
    func navigateToHomeScreen()
}

protocol FoodJourneyUseCase: FoodJourneyRequestFormatter {
    // TODO: Declare use case methods
}

protocol FoodJourneyRequestFormatter: class {
    func sendFoodJourneyRequest()
}

protocol FoodJourneyWebService: class {
    func requestFoodJourneyRequest(path: String)
}

protocol FoodJourneyObjectmapper: class {
    func foodJourneyDetails(data: Result<FoodJourney>)
}

protocol FoodJourneyInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol FoodJourneyWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}
