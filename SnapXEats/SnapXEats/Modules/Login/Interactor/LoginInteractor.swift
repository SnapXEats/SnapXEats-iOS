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
    var output: Result?
    
    private init() {}
    static  var  singletenInstance = LoginInteractor()
    //   var apiDataManager = ProfileApiDataManager()
    //  var localDataManager = ProfileLocalDataManager()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    
    func sendFaceBookLoginRequest(view: LoginView?) {
        if checkRechability() {
            self.view = view as? UIViewController
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends ], viewController: self.view) { [weak self] loginResult in
                guard let strongSelf = self else { return }
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    strongSelf.output?.result(result: NetworkResult.success)
                }
            }
        }
    }
}

extension LoginInteractor {
    
    func sendInstagramRequest(request: URLRequest) -> Bool {
        return  checkRechability() ? checkRequestForCallbackURL(request: request) : false
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(InstagramEnum.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            //requestURLString.substring(from: range.upperBound) // swift 3
            let newStr = String(requestURLString[range.upperBound...]) // swift 4
            handleAuth(authToken: newStr)
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
    }
    
    func checkRechability() -> Bool {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.result(result: .noInternet)
            return false
        } else {
            return true
        }
        
    }
}
