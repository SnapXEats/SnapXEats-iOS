//
//  SnapNShareHomeContract.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol SnapNShareHomeView: class, BaseView {
    // TODO: Declare view methods
}

protocol SnapNShareHomePresentation: class {
    func gotoSnapNSharePhotoView(parent: UINavigationController, withPhoto photo: UIImage)
}

protocol SnapNShareHomeUseCase: class {
    // TODO: Declare use case methods
}

protocol SnapNShareHomeInteractorOutput: class {
    // TODO: Declare interactor output methods
}

protocol SnapNShareHomeWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}
