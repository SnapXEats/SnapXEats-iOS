//
//  WishlistInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class WishlistInteractor {

    static let shared = WishlistInteractor()
    private init() {}
    
    // MARK: Properties

    weak var output: WishlistInteractorOutput?
}

extension WishlistInteractor: WishlistUseCase {
    // TODO: Implement use case methods
}
