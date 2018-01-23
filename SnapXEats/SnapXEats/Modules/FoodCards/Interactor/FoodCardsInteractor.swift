//
//  FoodCardsInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class FoodCardsInteractor {

    // MARK: Properties

    weak var output: FoodCardsInteractorOutput?
    private init() {}
    static let singleInstance = FoodCardsInteractor()
}

extension FoodCardsInteractor: FoodCardsUseCase {
    // TODO: Implement use case methods
}
