//
//  UserPreferencePresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class UserPreferencePresenter {

    // MARK: Properties

    weak var view: UserPreferenceView?
    var router: UserPreferenceWireframe?
    var interactor: UserPreferenceUseCase?
}

extension UserPreferencePresenter: UserPreferencePresentation {
    // TODO: implement presentation methods
}

extension UserPreferencePresenter: UserPreferenceInteractorOutput {
    // TODO: implement interactor output methods
}
