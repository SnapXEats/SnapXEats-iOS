//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import UIKit

protocol LoginView: BaseView  {
    var presenter: LoginViewPresentation? {get set}
}

protocol LoginViewPresentation {
    func loginUsingFaceBook()
    func loginUsingInstagram()
    func skipUserLogin()
}

protocol LoginViewInteractorInput: class {
    func sendFaceBookLoginRequest(view: LoginView?)
}

protocol LoginViewInteractorOutput: class, Response {
    func onLoginReguestFailure(message: String)
}

protocol LoginViewWireframe: class, RootWireFrame {
    func loadLoginModule() -> LoginView
}
