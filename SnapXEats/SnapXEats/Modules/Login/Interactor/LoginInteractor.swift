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
import SwiftInstagram

class LoginInteractor {
    
    // MARK: Properties
    private var view : LoginViewController?
    var output: LoginViewInteractorOutput?
    private init() {}
    static  var  singletenInstance = LoginInteractor()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    
    func sendFaceBookLoginRequest(view: LoginView?) {
        if checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends, ], viewController: self.view) { [weak self] loginResult in
                switch loginResult {
                case .failed( _):
                    self?.output?.response(result: NetworkResult.error)
                case .cancelled:
                    self?.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    self?.view?.showLoading()
                    self?.updateLoginUserData(accessToken: accessToken)
                }
            }
        }
    }
    
    private func updateLoginUserData(accessToken: AccessToken) {
        // Send Login User info to server
        sendUserInfo(path: SnapXEatsWebServicePath.snapXEatsUser, accessToken: accessToken, platform: SnapXEatsConstant.platFormFB) {[weak self] result in
            switch result {
            case .success(let data):
                if let userInfo = data as? UserProfile, let serverID = userInfo.userInfo?.user_id  {
                    SnapXEatsLoginHelper.shared.getUserProfileData(serverID: serverID, accessToken: accessToken) { (result) in
                        if let userId = accessToken.userId {
                            SnapXEatsLoginHelper.shared.saveloginInfo(userId: userId, plateform: SnapXEatsConstant.platFormFB)
                        }
                        self?.output?.response(result: result)
                    }
                }
            case .noInternet:
                self?.output?.response(result: .noInternet)
            default: break
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
        return  false //checkRechability() ? checkRequestForCallbackURL(request: request) : false
    }
    
    func updateInstagramUserData(accessToken: String, instagramUser: InstagramUser, completionHandler: @escaping ()-> ()) {
        sendInstagramUserInfo(path: SnapXEatsWebServicePath.snapXEatsUser, accessToken: accessToken, instagramUser: instagramUser, platform: SnapXEatsConstant.platFormInstagram) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let userInfo = data as? UserProfile, let serverID = userInfo.userInfo?.user_id, let serverToken = userInfo.userInfo?.token  {
                    SnapXEatsLoginHelper.shared.saveloginInfo(userId: instagramUser.id, plateform: SnapXEatsConstant.platFormInstagram)
                    SnapXEatsLoginHelper.shared.saveInstagramLoginData(serverToken: serverToken, serverID: serverID, instagram: instagramUser)
                    completionHandler()
                    self?.output?.response(result: result)
                }
            case .noInternet:
                completionHandler()
                self?.output?.response(result: .noInternet)
            default: break
            }
        }
    }
    
    func getInstagramUserData(completionHandler: @escaping ()-> ()) {
        let instagramApi = Instagram.shared
        if checkRechability()  {
            view?.showLoading()
            instagramApi.user("self", success: { (instagram) in
                if let accessToken = instagramApi.retrieveAccessToken() {
                    self.updateInstagramUserData(accessToken: accessToken, instagramUser: instagram, completionHandler: completionHandler)
                }
            }) {[weak self](error) in
                self?.output?.response(result: .noInternet)
            }
        }
    }
    
    func sendInstagramUserInfo(path: String, accessToken: String, instagramUser: InstagramUser, platform: String, completionHandler: @escaping (_ result: NetworkResult) -> ()) {
        let parameter:[String: String] = [SnapXEatsConstant.userLoginToken : accessToken,
                                          SnapXEatsConstant.social_platform : platform,
                                          SnapXEatsConstant.social_id: instagramUser.id
            
        ]
        SnapXEatsApi.snapXPostRequestObjectWithParameters(path: path, parameters: parameter) { [weak self] (response: DataResponse<UserProfile>) in
            let result = response.result
            self?.sendUserInfoSuccess(data: result, completionHandler: completionHandler)
        }
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
