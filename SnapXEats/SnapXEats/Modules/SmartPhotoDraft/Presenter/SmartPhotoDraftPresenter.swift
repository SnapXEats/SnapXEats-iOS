//
//  SmartPhotoDraftPresenter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
class SmartPhotoDraftPresenter {

    // MARK: Properties

    weak var baseView: BaseView?
    var router: SmartPhotoDraftWireframe?
    var interactor: SmartPhotoDraftUseCase?
    private init() {}
    static let shared = SmartPhotoDraftPresenter()
}

extension SmartPhotoDraftPresenter: SmartPhotoDraftPresentation {
    func presentView(screen: DraftScreen) -> UIViewController? {
       return  router?.loadScreen(screen: screen)
    }
    
    func presentScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
}

extension SmartPhotoDraftPresenter: SmartPhotoDraftInteractorOutput {

}
