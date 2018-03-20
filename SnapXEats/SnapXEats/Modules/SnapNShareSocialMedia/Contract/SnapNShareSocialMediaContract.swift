//
//  SnapNShareSocialMediaContract.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

protocol SnapNShareSocialMediaView: BaseView {
    // TODO: Declare view methods
}

protocol SnapNShareSocialMediaPresentation: class {
    func presentScreen(screen: Screens)
    func loginUsingFaceBook()
}

protocol SnapNShareSocialMediaUseCase: SnapNShareSocialMediaInPut {
    
}

protocol SnapNShareSocialMediaInPut: class {
   func sendFaceBookLoginRequest(view: BaseView?)
}

protocol SnapNShareSocialMediaInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol SnapNShareSocialMediaWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}
