//
//  SelectLocationPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SelectLocationPresenter {

    // MARK: Properties

    weak var view: SelectLocationView?
    var router: SelectLocationWireframe?
    var interactor: SelectLocationUseCase?
    
    private init() {}
    
    static let singleInstance = SelectLocationPresenter()
}

extension SelectLocationPresenter: SelectLocationPresentation {
    func dismissScreen() {
        router?.presentScreen(screen: .dismissNewLocation)
    }
}

extension SelectLocationPresenter: SelectLocationInteractorOutput {
    // TODO: implement interactor output methods
}
