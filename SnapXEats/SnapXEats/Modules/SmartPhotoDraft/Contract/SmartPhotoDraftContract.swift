//
//  SmartPhotoDraftContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol SmartPhotoDraftView: BaseView {
    var presenter: SmartPhotoDraftPresentation? {get set}
}

protocol SmartPhotoDraftPresentation: class {
    func presentScreen(screen: DraftScreen) -> UIViewController?
}

protocol SmartPhotoDraftUseCase: class {
    // TODO: Declare use case methods
}

protocol SmartPhotoDraftInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol SmartPhotoDraftWireframe: RootWireFrame {
    func loadScreen(screen: DraftScreen) -> UIViewController
}
