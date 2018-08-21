//
//  InstagramLoginInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import FacebookLogin
import FacebookCore
import RealmSwift
import SwiftInstagram

class InstagramLoginInteractor {

    var view : InstagramLoginView?
    private init() {}
    static  var  shared = InstagramLoginInteractor()

     var output: InstagramLoginInteractorOutput?
}

extension InstagramLoginInteractor: InstagramLoginUseCase {
    // TODO: Implement use case methods
}

extension InstagramLoginInteractor {
    
    func updateInstagramUserData(accessToken: String, instagramUser: InstagramUser, completionHandler: @escaping ()-> ()) {
        sendInstagramUserInfo(path: SnapXEatsWebServicePath.snapXEatsUser, accessToken: accessToken, instagramUser: instagramUser, platform: SnapXEatsConstant.platFormInstagram) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let userInfo = data as? UserProfile, let serverID = userInfo.userInfo?.user_id, let serverToken = userInfo.userInfo?.token,
                    let firstTimeUser = userInfo.userInfo?.first_time_login {
                    let rewardsPoint: Int64 = userInfo.userInfo?.userRewardPoint ?? 0
                    SnapXEatsLoginHelper.shared.saveloginInfo(userId: instagramUser.id, firstTimeLogin: firstTimeUser, plateform: SnapXEatsConstant.platFormInstagram)
                    SnapXEatsLoginHelper.shared.saveInstagramLoginData(rewardsPoints: rewardsPoint, serverToken: serverToken, serverID: serverID, instagram: instagramUser)
                    self?.saveWishList(userInfo: userInfo)
                    self?.sendUserPreferenceRequest(path: SnapXEatsWebServicePath.userPreferene, completionHandler: completionHandler)
                }
            case .noInternet:
                completionHandler()
                self?.output?.response(result: .noInternet)
            default: break
            }
        }
    }
    
    private func saveWishList(userInfo: UserProfile?) {
        if let list = userInfo?.userInfo?.wishList, list.count > 0 {
            FoodCardActionHelper.shared.addWishListWhenLogin(wishList: list)
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
                    completion()  // This will dissmiss the instagramviewControl
                }
            }
            output?.response(result: .success(data: value))  // This will navigate to the next screen
        case .failure( _):
            if  let completion = completionHandler {
                completion()  //This will dissmiss the instagramviewControl
            }
            output?.response(result: NetworkResult.noInternet)
        }
    }
    
    func checkRechability() -> Bool {
        if !SnapXEatsNetworkManager.shared.isConnectedToInternet {
            output?.response(result: .noInternet)
            return false
        } else {
            return true
        }
    }
}
