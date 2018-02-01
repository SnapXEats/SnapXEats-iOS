//
//  FoodCardsContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

protocol FoodCardsView: class, BaseView {
    var presenter: FoodCardsPresentation? {get set}
    func initView()
}

protocol FoodCardsPresentation: class {
    // TODO: Declare presentation methods
}

protocol FoodCardsUseCase: class {
    // TODO: Declare use case methods
}

protocol FoodCardsInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol FoodCardsWireframe: class, RootWireFrame {
    // TODO: Declare wireframe methods
}
