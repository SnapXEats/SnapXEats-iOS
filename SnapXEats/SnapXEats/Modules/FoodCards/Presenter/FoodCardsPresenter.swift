//
//  FoodCardsPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class FoodCardsPresenter {

    // MARK: Propertiesx
    var baseView: BaseView?
    var router: FoodCardsWireframe?
    var interactor: FoodCardsRequestFomatter?
    
    private init() {}
    static let singleInstance = FoodCardsPresenter()
}

extension FoodCardsPresenter: FoodCardsPresentation {
    
    func getFoodCards(selectedPreferences: SelectedPreference?) {
        interactor?.sendFoodCardRequest(selectedPreferences: selectedPreferences)
    }
    
    func refreshFoodCards() {
        router?.presentScreen(screen: .location)
    }
}

extension FoodCardsPresenter: FoodCardsInteractorOutput {
}
