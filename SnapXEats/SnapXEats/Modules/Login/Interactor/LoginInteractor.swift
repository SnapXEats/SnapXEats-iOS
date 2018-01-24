//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.


import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import FacebookLogin
import FacebookCore

class LoginInteractor {
    
    // MARK: Properties
    private var view : UIViewController?
    var output: Response?
    
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
                case .failed(let _):
                    strongSelf.output?.response(result: NetworkResult.error)
                case .cancelled:
                    strongSelf.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    strongSelf.output?.response(result: NetworkResult.success(data: nil))
                    
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
        if requestURLString.hasPrefix(InstagramConstant.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            //requestURLString.substring(from: range.upperBound) // swift 3
            let newStr = String(requestURLString[range.upperBound...]) // swift 4
            handleAuth(authToken: newStr)
            return false;
        }
        UserDefaults.standard.set(true, forKey: InstagramConstant.INSTAGRAM_LOGGEDIN)
        return true
    }
    func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
    }
    
    func checkRechability() -> Bool {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.response(result: .noInternet)
            return false
        } else {
            return true
        }
    }
}
