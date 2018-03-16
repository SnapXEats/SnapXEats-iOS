//
//  SnapNSharePhotoContract.swift
//  SnapXEats
//
//  Created by synerzip on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol SnapNSharePhotoView: class, BaseView {
    // TODO: Declare view methods
}

protocol SnapNSharePhotoPresentation: class {
    func gotoSnapNSharesocialMediaView(parent: UINavigationController)
}

protocol SnapNSharePhotoUseCase: class {
    // TODO: Declare use case methods
}

protocol SnapNSharePhotoInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol SnapNSharePhotoWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}
