//
//  LoginPopUpContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

protocol LoginPopUpView: BaseView {
    
}

protocol LoginPopUpPresentation: class {
    func presentScreen(screen: Screens)
    func loginFaceBook(view: UIViewController)
    func loginInstagram(parentController: UINavigationController)
}

protocol LoginPopUpInteractorInPut: class {
    func sendLoginFaceBook(view: UIViewController)
    func sendLoginInstagram()
}

protocol LoginPopUpInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol LoginPopUpWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}
