

//
//  File.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookShare
import FacebookCore

enum FBLoginConstant {
    static let loginId = "id"
    static let loginName = "name"
    static let pictureSizeSmall = "picture.width(480).height(480)"
    static let pictureSizelarge = "picture.type(large)"
    static let picture = "picture"
    static let data = "data"
    static let pictureURL = "url"
    static let email = "email"
}
class SnapXEatsLoginHelper {
    
    static let shared = SnapXEatsLoginHelper()
    private init() {}
    
    private func saveFBLoginData(serverID: String, accessToken: AccessToken, response: [String : Any]?) {
        if let dict = response, let userID =  dict[FBLoginConstant.loginId] as? String,
            let userName = dict[FBLoginConstant.loginName] as? String,
            let email = dict[FBLoginConstant.email] as? String,
            let picture = dict[FBLoginConstant.picture] as? [String: Any] ,
            let data = picture[FBLoginConstant.data] as? [String: Any],
            let imageURL =  data[FBLoginConstant.pictureURL] as? String {
            let fblogin = FBLogin()
            fblogin.Id = userID
            fblogin.serverUserID = serverID
            fblogin.name = userName
            fblogin.email = email
            fblogin.imageURL = imageURL
            fblogin.accessToken = accessToken.authenticationToken
            fblogin.expireDate = accessToken.expirationDate
            FBLogin.createUserProfile(fbLogin: fblogin)
        }
    }
    
    func getUserProfileData(serverID: String, accessToken: AccessToken,  completionHandler: @escaping (_ result: NetworkResult) -> ()) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me" , parameters : ["fields" : "\(FBLoginConstant.email), \(FBLoginConstant.loginId), \(FBLoginConstant.loginName), \(FBLoginConstant.pictureSizeSmall)"])) {[weak self] httpResponse, result in
            switch result {
            case .success(let response):
                self?.saveFBLoginData(serverID: serverID, accessToken: accessToken, response: response.dictionaryValue)
                completionHandler(.success(data: accessToken))
                
            case .failed(_):
                completionHandler(.noInternet)
            }
        }
        connection.start()
    }
    
    func saveloginInfo(userId: String, plateform: String) {
        let loginData = [SnapXEatsConstant.loginID: userId, SnapXEatsConstant.social_platform: plateform]
        UserDefaults.standard.set(loginData, forKey: SnapXEatsConstant.snapXLoginData)
    }
    
    func getloginInfo() -> FBLogin? {
        guard let userInfo = UserDefaults.standard.value(forKey: SnapXEatsConstant.snapXLoginData) as? [String: String],
            let loginId = userInfo[SnapXEatsConstant.loginID], let fbLoginInfo = getFBLoginInfo(id: loginId) else {
                return nil
        }
        return fbLoginInfo
    }
    
    private func getFBLoginInfo(id: String) -> FBLogin? {
        return FBLogin.getUserProfile(id: id)
    }
    
    func fbHelper() -> Bool {
        var fbLoggedIn = false
        if let fbLoginInfo  =  getloginInfo() {
            if Date() > fbLoginInfo.expireDate {
                AccessToken.refreshCurrentToken({ (accessToken, error) in
                    if error == nil {
                        FBLogin.updateExpireDate(currentDate: fbLoginInfo.expireDate, newDate: accessToken?.expirationDate ?? Date())
                    }
                })
                fbLoggedIn = true
            } else {
                fbLoggedIn = true
            }
        }
        return fbLoggedIn
    }
}
