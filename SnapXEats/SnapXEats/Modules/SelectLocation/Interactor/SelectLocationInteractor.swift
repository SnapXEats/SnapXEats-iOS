//
//  SelectLocationInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SelectLocationInteractor {

    // MARK: Properties

    weak var output: SelectLocationInteractorOutput?
    
    private init() {}
    
    static let singleInstance = SelectLocationInteractor()
}

extension SelectLocationInteractor: SelectLocationUseCase {
    // TODO: Implement use case methods
}
