//
//  SmartPhotoDraftInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SmartPhotoDraftInteractor {

    // MARK: Properties

    weak var output: SmartPhotoDraftInteractorOutput?
    private init() {}
    static let shared = SmartPhotoDraftInteractor()
}

extension SmartPhotoDraftInteractor: SmartPhotoDraftUseCase {
    // TODO: Implement use case methods
}
