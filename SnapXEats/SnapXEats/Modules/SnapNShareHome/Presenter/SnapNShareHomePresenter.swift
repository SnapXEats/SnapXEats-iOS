//
//  SnapNShareHomePresenter.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SnapNShareHomePresenter {

    // MARK: Properties

    weak var view: SnapNShareHomeView?
    var router: SnapNShareHomeWireframe?
    var interactor: SnapNShareHomeUseCase?
    
    static let shared = SnapNShareHomePresenter()
    private init() {}
}

extension SnapNShareHomePresenter: SnapNShareHomePresentation {
    // TODO: implement presentation methods
}

extension SnapNShareHomePresenter: SnapNShareHomeInteractorOutput {
    // TODO: implement interactor output methods
}
