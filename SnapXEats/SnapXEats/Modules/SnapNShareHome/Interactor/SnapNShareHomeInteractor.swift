//
//  SnapNShareHomeInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SnapNShareHomeInteractor {

    // MARK: Properties

    weak var output: SnapNShareHomeInteractorOutput?
    
    static let shared = SnapNShareHomeInteractor()
    private init() {}
}

extension SnapNShareHomeInteractor: SnapNShareHomeUseCase {
    // TODO: Implement use case methods
}
