//
//  SnapNSharePhotoPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNSharePhotoPresenter {

    // MARK: Properties
    weak var view: SnapNSharePhotoView?
    var router: SnapNSharePhotoWireframe?
    var interactor: SnapNSharePhotoUseCase?
}

extension SnapNSharePhotoPresenter: SnapNSharePhotoPresentation {
    func gotoSnapNSharesocialMediaView(parent: UINavigationController) {
        router?.presentScreen(screen: .snapNShareSocialMedia(parentController: parent))
    }
}

extension SnapNSharePhotoPresenter: SnapNSharePhotoInteractorOutput {
    // TODO: implement interactor output methods
}