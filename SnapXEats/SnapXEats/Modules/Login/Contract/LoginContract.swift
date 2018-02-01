//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import UIKit

protocol LoginView: BaseView {
    var presenter: LoginViewPresentation? {get set}
    func initView()
}

protocol LoginViewPresentation: LoginViewPresentationInstagram {
    func loginUsingInstagram()
    func loginUsingFaceBook()
    func setView(view: LoginView)
    func skipUserLogin()
    func showLocationScreen()
}

protocol LoginViewPresentationInstagram: class {
        func instagramLoginRequest(request: URLRequest) -> Bool
        func removeInstagramWebView()
}
protocol LoginViewInteractorInput: class {
    func sendFaceBookLoginRequest(view: LoginView?)
    func sendInstagramRequest(request: URLRequest) -> Bool
}

protocol LoginViewInteractorOutput: class {
    func onLoginReguestFailure(message: String)
}

protocol LoginViewWireframe: class, RootWireFrame {
    func loadLoginModule() -> LoginView
    func loadInstagramView() -> LoginView
}
