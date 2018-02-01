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
    var interactor: FoodCardsUseCase?
    
    static let singleInstance = FoodCardsPresenter()
}

extension FoodCardsPresenter: FoodCardsPresentation {
    // TODO: implement presentation methods
}

extension FoodCardsPresenter: FoodCardsInteractorOutput {
    // TODO: implement interactor output methods
}
