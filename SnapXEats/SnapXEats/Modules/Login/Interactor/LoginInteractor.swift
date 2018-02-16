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
import RealmSwift

class LoginInteractor {
    
    // MARK: Properties
    private var view : LoginViewController?
    var output: LoginViewInteractorOutput?
    
    private init() {}
    static  var  singletenInstance = LoginInteractor()
    //   var apiDataManager = ProfileApiDataManager()
    //  var localDataManager = ProfileLocalDataManager()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    
    func sendFaceBookLoginRequest(view: LoginView?) {
        if checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends, ], viewController: self.view) { [weak self] loginResult in
                guard let strongSelf = self else { return }
                switch loginResult {
                case .failed( _):
                    strongSelf.output?.response(result: NetworkResult.error)
                case .cancelled:
                    strongSelf.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    
                    self?.view?.showLoading()
                    // Send Login User info to server
                    self?.sendUserInfo(path: SnapXEatsWebServicePath.snapXEatsUser, accessToken: accessToken, platform: SnapXEatsConstant.platFormFB) { result in
                        switch result {
                        case .success(let data):
                            if let userInfo = data as? UserProfile, let serverID = userInfo.userInfo?.user_id  {
                                SnapXEatsLoginHelper.shared.getUserProfileData(serverID: serverID, accessToken: accessToken) { (result) in
                                    if let userId = accessToken.userId {
                                        SnapXEatsLoginHelper.shared.saveloginInfo(userId: userId, plateform: SnapXEatsConstant.platFormFB)
                                    }
                                    strongSelf.output?.response(result: result)
                                }
                            }
                        case .noInternet:
                            strongSelf.output?.response(result: .noInternet)
                        default: break
                        }
                        
                    }
                }
            }
        }
    }
}

extension LoginInteractor {
    func sendUserInfo(path: String, accessToken: AccessToken, platform: String, completionHandler: @escaping (_ result: NetworkResult) -> ()) {
        let parameter:[String: String] = [SnapXEatsConstant.userLoginToken : accessToken.authenticationToken,
                                          SnapXEatsConstant.social_platform : platform,
                                          SnapXEatsConstant.social_id: accessToken.userId ?? ""
            
        ]
        SnapXEatsApi.snapXPostRequestObjectWithParameters(path: path, parameters: parameter) { [weak self](response: DataResponse<UserProfile>) in
            let result = response.result
            self?.sendUserInfoSuccess(data: result, completionHandler: completionHandler)
        }
    }
    
    func sendUserInfoSuccess(data: Result<UserProfile>, completionHandler: @escaping (_ result: NetworkResult) -> ()) {
        switch data {
        case .success(let value):
            completionHandler(.success(data: value))
        case .failure( _):
            completionHandler(.noInternet)
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
        if !SnapXEatsNetworkManager.sharedInstance.isConnectedToInternet {
            output?.response(result: .noInternet)
            return false
        } else {
            return true
        }
    }
}
