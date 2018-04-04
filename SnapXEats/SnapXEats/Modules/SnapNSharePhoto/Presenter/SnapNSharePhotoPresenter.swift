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
    private init(){}
    static let shared = SnapNSharePhotoPresenter()
}

extension SnapNSharePhotoPresenter: SnapNSharePhotoPresentation {
    func gotoSnapNSharesocialMediaView(parent: UINavigationController) {
        router?.presentScreen(screen: .snapNShareSocialMedia(parentController: parent))
    }
    
    func presentScreenLoginPopup(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
}

extension SnapNSharePhotoPresenter: SnapNSharePhotoInteractorOutput {
    // TODO: implement interactor output methods
}
