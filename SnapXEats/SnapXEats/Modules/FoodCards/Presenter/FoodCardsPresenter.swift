//
//  FoodCardsPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class FoodCardsPresenter {

    // MARK: Properties

    weak var view: FoodCardsView?
    var router: FoodCardsWireframe?
    var interactor: FoodCardsRequestFomatter?
    
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
    func response(result: NetworkResult) {
        switch result {
        case .success(let value):
            view?.success(result: value)
        case .error:
            view?.error(result: .error)
        case .noInternet:
            view?.error(result: .noInternet)
        default: break
        }
    }
}
