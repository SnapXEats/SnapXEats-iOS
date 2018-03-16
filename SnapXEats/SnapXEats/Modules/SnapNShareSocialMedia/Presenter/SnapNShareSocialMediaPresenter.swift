//
//  SnapNShareSocialMediaPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SnapNShareSocialMediaPresenter {

    // MARK: Properties

    weak var view: SnapNShareSocialMediaView?
    var router: SnapNShareSocialMediaWireframe?
    var interactor: SnapNShareSocialMediaUseCase?
}

extension SnapNShareSocialMediaPresenter: SnapNShareSocialMediaPresentation {
    // TODO: implement presentation methods
}

extension SnapNShareSocialMediaPresenter: SnapNShareSocialMediaInteractorOutput {
    // TODO: implement interactor output methods
}
