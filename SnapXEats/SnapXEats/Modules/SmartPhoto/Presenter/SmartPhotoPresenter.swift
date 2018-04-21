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
    
    func showSuccess() {
        router?.presentSmartPhotoView(view: .success)
    }
    
    func pausePlayAudio() {
        router?.pausePlayAudio()
    }
    
    func presentScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
    
    func saveSmartPhoto(smartPhoto: SmartPhoto) {
        interactor?.storeSmartPhoto(smartPhoto: smartPhoto)
    }
    
    func checkSmartPhoto(smartPhotoID: String) -> Bool {
        if let interactor = interactor {
            return interactor.alreadyExistingSmartPhoto(smartPhotoID: smartPhotoID)
        }
        return false
    }
    
}

extension SmartPhotoPresenter: SmartPhotoInteractorOutput {
    // TODO: implement interactor output methods
}
