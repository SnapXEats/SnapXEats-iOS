//
//  smartPhotoPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class SmartPhotoPresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: SmartPhotoWireframe?
    var interactor: SmartPhotoUseCase?
    
    static let shared = SmartPhotoPresenter()
    private init() {}
}

extension SmartPhotoPresenter: SmartPhotoPresentation {
    func getSmartPhotoDetails(dishID: String) {
        interactor?.sendSmartPhotoRequest(dishID: dishID)
    }
    
    func presentView(view: SmartPhotView) {
        router?.presentSmartPhotoView(view: view)
    }
}

extension SmartPhotoPresenter: SmartPhotoInteractorOutput {
    // TODO: implement interactor output methods
}
