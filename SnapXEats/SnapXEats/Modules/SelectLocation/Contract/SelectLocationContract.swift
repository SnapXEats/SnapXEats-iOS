//
//  SelectLocationContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

protocol SelectLocationView: class, BaseView {
    var presenter: SelectLocationPresentation? {get set}
    func initView()
}

protocol SelectLocationPresentation: class {
    func dismissScreen()
}

protocol SelectLocationUseCase: class {
    // TODO: Declare use case methods
}

protocol SelectLocationInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol SelectLocationWireframe: class, RootWireFrame {
}
