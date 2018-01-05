//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.


import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import FacebookLogin

class LoginInteractor {
    
    // MARK: Properties
    private var view : UIViewController?
    weak var output: LoginViewInteractorOutput?
    
    private init() {}
    static  var  singletenInstance = LoginInteractor()
 //   var apiDataManager = ProfileApiDataManager()
  //  var localDataManager = ProfileLocalDataManager()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    
    
    func sendInstagramRequest(view: LoginView?) {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.onLoginReguestFailure(message: "NO_INTERNET")
            return
        }
    }
    
    func sendFaceBookLoginRequest(view: LoginView?) {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.onLoginReguestFailure(message: "NO_INTERNET")
            return
        }
        self.view = view as? UIViewController
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends ], viewController: self.view) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }

}
