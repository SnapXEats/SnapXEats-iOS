

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
import SwiftInstagram

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
            let fblogin = UserLogin()
            fblogin.Id = userID
            fblogin.serverUserID = serverID
            fblogin.name = userName
            fblogin.email = email
            fblogin.imageURL = imageURL
            fblogin.accessToken = accessToken.authenticationToken
            fblogin.expireDate = accessToken.expirationDate
            UserLogin.createUserProfile(login: fblogin)
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
        let loginData = [SnapXEatsConstant.loginID: userId, SnapXEatsConstant.social_platform: plateform, SnapXEatsConstant.snaXEatsFirstTimeUser: SnapXEatsConstant.firstTimeUser]
        UserDefaults.standard.set(loginData, forKey: SnapXEatsConstant.snapXLoginData)
    }
    
    func getloginInfo() -> UserLogin? {
        guard let userInfo = getSnapXLoginData(),
            let loginId = userInfo[SnapXEatsConstant.loginID], let userLoginInfo = getUserLoginInfo(id: loginId) else {
                return nil
        }
        return userLoginInfo
    }
    
    func setNotAFirstTimeUser() {
        if var userInfo =  getSnapXLoginData() {
            userInfo[SnapXEatsConstant.snaXEatsFirstTimeUser] = SnapXEatsConstant.emptyString
            UserDefaults.standard.set(userInfo, forKey: SnapXEatsConstant.snapXLoginData)
        }
    }
    
    func firstTimeUser() -> Bool {
        guard let userInfo = getSnapXLoginData(),
            let firstTime = userInfo[SnapXEatsConstant.snaXEatsFirstTimeUser] else {
                return false
        }
        return firstTime == SnapXEatsConstant.firstTimeUser
    }
    
    func getSnapXLoginData() -> [String: String]? {
        return UserDefaults.standard.value(forKey: SnapXEatsConstant.snapXLoginData) as? [String: String]
    }
    
    func getLoggedInUserID() -> String {
        guard let userInfo = getSnapXLoginData(),
            let loginID = userInfo[SnapXEatsConstant.loginID] else {
                return SnapXEatsConstant.emptyString
        }
        return loginID
    }
    
    func isUserLoggedIn() -> Bool {
        return getLoggedInUserID() != SnapXEatsConstant.emptyString
    }
    
    
    private func getUserLoginInfo(id: String) -> UserLogin? {
        return UserLogin.getUserProfile(id: id)
    }
    
    func fbHelper() -> Bool {
        var fbLoggedIn = false
        if let fbLoginInfo  =  getloginInfo() {
            if Date() > fbLoginInfo.expireDate {
                AccessToken.refreshCurrentToken({ (accessToken, error) in
                    if error == nil {
                        UserLogin.updateExpireDate(currentDate: fbLoginInfo.expireDate, newDate: accessToken?.expirationDate ?? Date())
                    }
                })
                fbLoggedIn = true
            } else {
                fbLoggedIn = true
            }
        }
        return fbLoggedIn
    }
    
    func deleteLoginData() {
        UserDefaults.standard.removeObject(forKey: SnapXEatsConstant.snapXLoginData)
        UserLogin.deleteStoredLogedInUser()
    }
}

extension SnapXEatsLoginHelper {
    func saveInstagramLoginData(serverToken: String, serverID: String, instagram: InstagramUser) {
        if let accesToken = Instagram.shared.retrieveAccessToken() {
            let login = UserLogin()
            login.Id = instagram.id
            login.serverUserID = serverID
            login.serverUserToken = serverToken
            login.name = instagram.fullName
            login.imageURL = instagram.profilePicture.absoluteString
            login.accessToken = accesToken
            UserLogin.createUserProfile(login: login)
        }
    }
}