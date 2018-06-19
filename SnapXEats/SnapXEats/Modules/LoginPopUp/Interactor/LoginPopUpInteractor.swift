//
//  LoginPopUpInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import Alamofire
import ObjectMapper
import FBSDKShareKit

class LoginPopUpInteractor {

    // MARK: Properties
    
    var output: LoginPopUpInteractorOutput?
    private init() {}
    static let shared = LoginPopUpInteractor()
}

extension LoginPopUpInteractor: LoginPopUpInteractorInPut {
    
    func sendLoginFaceBook(view: UIViewController) {
        if  let view = view as? LoginPopUpViewController, view.checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(publishPermissions: [.publishActions], viewController: view) { [weak self] loginResult in
                switch loginResult {
                case .failed( _):
                    self?.output?.response(result: NetworkResult.error)
                case .cancelled:
                    self?.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    view.showLoading()
                    self?.updateLoginUserData(accessToken: accessToken)
                   // self?.output?.response(result: .success(data: true))
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
            let rewardsPoint: Int64 = userInfo.userInfo?.userRewardPoint ?? 0
            SnapXEatsLoginHelper.shared.getUserProfileData(rewardsPoint: rewardsPoint, serverID: serverID, serverToken: serverToken, accessToken: accessToken) {[weak self] (result) in
                
                switch result {
                case .success(_):
                    if let userId = accessToken.userId {
                        SnapXEatsLoginHelper.shared.saveloginInfo(userId: userId, firstTimeLogin: firstTimeUser, plateform: SnapXEatsConstant.platFormFB)
                        // Save also as second time login as FB, so there will no login FB dialog show again
                        SocialPlatformHelper.shared.saveSecondSocialLoginInfoAsFB(accessToken: accessToken)
                        self?.output?.response(result: .success(data: true))
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
    
    
    
    func sendLoginInstagram() {
        
    }
    
    // TODO: Implement use case methods
}
