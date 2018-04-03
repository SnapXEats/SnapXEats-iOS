//
//  SnapNSharePhotoInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SnapNSharePhotoInteractor {

    // MARK: Properties

    weak var output: SnapNSharePhotoInteractorOutput?
    private init() {}
    static let shared = SnapNSharePhotoInteractor()
}

extension SnapNSharePhotoInteractor: SnapNSharePhotoUseCase {
    // TODO: Implement use case methods
}
