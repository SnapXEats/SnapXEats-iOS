//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.


import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift


class LoginInteractor {
    
    // MARK: Properties
    
    weak var output: LoginViewInteractorOutput?
 //   var apiDataManager = ProfileApiDataManager()
  //  var localDataManager = ProfileLocalDataManager()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    func sendInstagramRequest(userName: String, pwd: String) {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.onLoginReguestFailure(message: "NO_INTERNET")
            return
        }
    }
    
    func sendFaceBookLoginRequest(userName: String, pwd: String) {
        if Reachability()?.currentReachabilityStatus == .notReachable {
            output?.onLoginReguestFailure(message: "NO_INTERNET")
            return
        }
    }

}
