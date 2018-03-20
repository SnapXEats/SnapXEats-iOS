//
//  SocialPlatformHelper.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookCore

class SocialPlatformHelper {
    private init(){}
    static let shared = SocialPlatformHelper()
    let loggedInPreference = LoginUserPreferences.shared
    
    func saveSocialLoginInfoAsFB(accessToken: AccessToken ) {
        if  SnapXEatsLoginHelper.shared.isLoggedUsingFB() {
            saveFBPermission(accessToken: accessToken)
        } else if SnapXEatsLoginHelper.shared.isLoggedUsingInstagram() {
            saveSecondSocialLoginInfoAsFB(accessToken: accessToken)
        }
        
    }
    
    func saveFBPermission(accessToken: AccessToken) {
        if let userId = accessToken.userId {
            let socialLogin = SecondSocialLogin()
            socialLogin.firstSocialId = userId
            socialLogin.firstSocialToken  = accessToken.authenticationToken
            socialLogin.firstSocialPlatForm = SnapXEatsConstant.platFormFB
            socialLogin.expireDateFBToken = accessToken.expirationDate
            socialLogin.authenticateSharingFB = true
            let predicate  =  NSPredicate(format: "firstSocialId == %@", userId)
            SecondSocialLogin.createSocialLogin(login: socialLogin, predicate: predicate)
        }
    }
    
    func saveSecondSocialLoginInfoAsFB(accessToken: AccessToken ) {
        if let loggedInUser = SnapXEatsLoginHelper.shared.getloginInfo(), let userId = accessToken.userId {
            let socialLogin = SecondSocialLogin()
            
            socialLogin.firstSocialId = loggedInUser.Id
            socialLogin.firstSocialToken = loggedInUser.accessToken
            socialLogin.firstSocialPlatForm = SnapXEatsConstant.platFormInstagram
            
            socialLogin.secondSocialId = userId
            socialLogin.secondSocialToken  = accessToken.authenticationToken
            socialLogin.expireDateFBToken = accessToken.expirationDate
            socialLogin.secondSocialPlatForm = SnapXEatsConstant.platFormFB
            socialLogin.authenticateSharingFB = true
            let predicate  =  NSPredicate(format: "secondSocialId == %@", userId)
            SecondSocialLogin.createSocialLogin(login: socialLogin, predicate: predicate)
        }
    }
    
    func fbSharingEnabled() -> Bool {
        return SecondSocialLogin.getFBAuthentication(userID: loggedInPreference.loginUserID)
    }
}
