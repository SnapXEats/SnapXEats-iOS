//
//  FoodCardsPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodCardsPresenter {

    // MARK: Propertiesx
    var baseView: BaseView?
    var router: FoodCardsWireframe?
    var interactor: FoodCardsRequestFomatter?
    
    private init() {}
    static let shared = FoodCardsPresenter()
}

extension FoodCardsPresenter: FoodCardsPresentation {
    
    func getFoodCards(selectedPreferences: SelectedPreference) {
        interactor?.sendFoodCardRequest(selectedPreference: selectedPreferences)
    }
    
    func refreshFoodCards() {
        router?.presentScreen(screen: .location)
    }
    
    func gotoRestaurantDetails(selectedRestaurant: String, parent: UINavigationController, showMoreInfo: Bool) {
        router?.presentScreen(screen: .restaurantDetails(restaurantID: selectedRestaurant, parentController: parent, showMoreInfo: showMoreInfo))
    }
    
    func sendUserGestures(gestures: [String: Any]) {
        interactor?.sendUserGestures(gestures: gestures)
    }
    
    func gotoRestaurantsMapView(restaurants: [Restaurant], parent: UINavigationController) {
        router?.presentScreen(screen: .restaurantsMapView(restaurants: restaurants, parentController: parent))
    }
}

extension FoodCardsPresenter: FoodCardsInteractorOutput {
}
