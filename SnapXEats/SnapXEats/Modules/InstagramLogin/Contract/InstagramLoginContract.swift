//
//  InstagramLoginContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol InstagramLoginView: BaseView {
    // TODO: Declare view methods
}

protocol InstagramLoginPresentation  {
    func removeInstagramWebView(sharedLoginFromSkip: Bool, parentController: UINavigationController?)
    func getInstagramUserData(completionHandler: @escaping ()-> ())
}

protocol InstagramLoginUseCase: InstagramLoginInteractorInput {
    // TODO: Declare use case methods
}

protocol InstagramLoginInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol InstagramLoginWireframe: RootWireFrame {
        func loadInstagramView() -> InstagramLoginView
}

protocol InstagramLoginInteractorInput: class {
    func getInstagramUserData(completionHandler: @escaping ()-> ())
}

