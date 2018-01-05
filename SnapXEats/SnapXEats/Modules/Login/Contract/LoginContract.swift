//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation


protocol LoginView: BaseView {
    func initView()
}

protocol LoginViewPresentation: class {
    func loginUsingFaceBook()
    func loginUsingInstagram()
}

protocol LoginViewInteractorInput: class {
    func sendFaceBookLoginRequest(view: LoginView?)
    func sendInstagramRequest(view: LoginView?)
}

protocol LoginViewInteractorOutput: class {
    func onLoginReguestFailure(message: String)
}

protocol LoginViewWireframe: class {
    
}
