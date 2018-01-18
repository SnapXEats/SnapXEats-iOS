//
//  LocationInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class LocationInteractor {

    // MARK: Properties

    weak var output: LocationInteractorOutput?
    private init() {}
    static let singleInstance = LocationInteractor()
}

extension LocationInteractor: LocationUseCase {
    // TODO: Implement use case methods
}
