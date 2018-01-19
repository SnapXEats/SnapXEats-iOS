//
//  LocationContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 18/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

protocol LocationView: class, BaseView {
    var presenter: LocationPresentation? {get set}
    func initView()
}

protocol LocationPresentation: class {
    // TODO: Declare presentation methods
        func closeLocationView()
        func selectLocation()
}

protocol LocationUseCase: class {
    // TODO: Declare use case methods
}

protocol LocationInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol LocationWireframe: class, RootWireFrame {
    func loadLocationModule() -> LocationView
}
