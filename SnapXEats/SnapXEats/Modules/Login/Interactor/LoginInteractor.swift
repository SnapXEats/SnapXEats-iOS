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
    var view : LoginView?
    var output: LoginViewInteractorOutput?
    private init() {}
    static  var  singletenInstance = LoginInteractor()
    
}

extension LoginInteractor: LoginViewInteractorInput {
    
    func sendFaceBookLoginRequest(view: LoginView?) {
        if  let view = view as? LoginViewController, checkRechability() {
            let loginManager = LoginManager()
           
            loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends, ], viewController: view) { [weak self] loginResult in
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
                    self?.saveUserData(accessToken: accessToken, data: data)
            case .noInternet:
                self?.output?.response(result: .noInternet)
            default: break
            }
            
        }
    }
    
    private func saveUserData(accessToken: AccessToken, data: Any?) {
        if let userInfo = data as? UserProfile, let serverID = userInfo.userInfo?.user_id, let serverToken = userInfo.userInfo?.token, let firstTimeUser = userInfo.userInfo?.first_time_login {
            SnapXEatsLoginHelper.shared.getUserProfileData(serverID: serverID, serverToken: serverToken, accessToken: accessToken) {[weak self] (result) in
                
                switch result {
                case .success(_):
                    if let userId = accessToken.userId {
                        SnapXEatsLoginHelper.shared.saveloginInfo(userId: userId, firstTimeLogin: firstTimeUser, plateform: SnapXEatsConstant.platFormFB)
                        self?.saveWishList(userInfo: userInfo)
                        self?.sendUserPreferenceRequest(path: SnapXEatsWebServicePath.userPreferene, completionHandler: nil)
                    } else {
                        self?.output?.response(result: .error)
                    }
                case .noInternet:
                    self?.output?.response(result: result)
                default: break
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
    
    func sendUserPreferenceRequest(path: String, completionHandler: (()-> ())?) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: path, parameters: [:]) {[weak self] (response: DataResponse<FirstTimeUserPreference>) in
            let result = response.result
            self?.preferenceDetails(data: result, completionHandler: completionHandler)
        }
    }
    
    
    // TODO: Implement use case methods
    func preferenceDetails(data: Result<FirstTimeUserPreference>, completionHandler: (()-> ())?) {
        switch data {
        case .success(let value):
            if let preferecne = value.userPreferences {
                PreferenceHelper.shared.saveFirstTimeLoginPreferecne(storedPreferecne: preferecne)
                if  let completion = completionHandler {
                    completion()
                }
            }
            output?.response(result: .success(data: value))
        case .failure( _):
            if  let completion = completionHandler {
                completion()
            }
            output?.response(result: NetworkResult.noInternet)
        }
    }
    
    private func saveWishList(userInfo: UserProfile?) {
        if let list = userInfo?.userInfo?.wishList, list.count > 0 {
            FoodCardActionHelper.shared.addWishListWhenLogin(wishList: list)
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
