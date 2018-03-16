//
//  InstagramLoginContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

protocol InstagramLoginView: BaseView {
    // TODO: Declare view methods
}

protocol InstagramLoginPresentation  {
    func showLocationScreen()
    func loginUsingInstagram()
    
    func instagramLoginRequest(request: URLRequest) -> Bool
    func removeInstagramWebView()
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
    func sendInstagramRequest(request: URLRequest) -> Bool
    func getInstagramUserData(completionHandler: @escaping ()-> ())
}

