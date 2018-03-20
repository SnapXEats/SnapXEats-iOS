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

    weak var baseView: BaseView?
    var router: SnapNShareSocialMediaWireframe?
    var interactor: SnapNShareSocialMediaUseCase?
}

extension SnapNShareSocialMediaPresenter: SnapNShareSocialMediaPresentation {
    func presentScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
    
    func loginUsingFaceBook() {
        interactor?.sendFaceBookLoginRequest(view: baseView)
    }
}

extension SnapNShareSocialMediaPresenter: SnapNShareSocialMediaInteractorOutput {    
    // TODO: implement interactor output methods
}
