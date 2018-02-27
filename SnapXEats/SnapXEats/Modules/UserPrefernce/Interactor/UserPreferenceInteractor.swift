//
//  UserPreferenceInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class UserPreferenceInteractor {

    // MARK: Properties
    var output: UserPreferenceInteractorOutput?
    static let shared = UserPreferenceInteractor()
    private init() {}
}

extension UserPreferenceInteractor: UserPreferenceInteractorIntput {

    func saveUserPreference(loginUserPreferences : LoginUserPreferences) {
        PreferenceHelper.shared.saveUserPrefernce(preference: loginUserPreferences)
    }
    
    func getUserPreference(userID: String) {
        if let prefernce = PreferenceHelper.shared.getUserPrefernce(userID: userID){
            output?.response(result: .success(data: prefernce))
        }
    }
}

extension UserPreferenceInteractor: UserPreferenceRequestFormatter {
    func sendUserPreference(preference: LoginUserPreferences) {
        PreferenceHelper.shared.saveUserPrefernce(preference: preference)
        if let prefernce = PreferenceHelper.shared.getUserPrefernce(userID: preference.loginUserID){
            let requestParameter = PreferenceHelper.shared.getJSONDataUserPrefernce()
            sendUserPreferences(forPath:SnapXEatsWebServicePath.userPreferene, withParameters: requestParameter)
        }
    }
    
    func updateUserPreference(preference: LoginUserPreferences) {
        PreferenceHelper.shared.saveUserPrefernce(preference: preference)
        if let prefernce = PreferenceHelper.shared.getUserPrefernce(userID: preference.loginUserID){
            let requestParameter = PreferenceHelper.shared.getJSONDataUserPrefernce()
            updateUserPreferences(forPath: SnapXEatsWebServicePath.userPreferene, withParameters: requestParameter)
        }
    }
    
}

extension UserPreferenceInteractor: UserPreferenceWebService {
    
    func sendUserPreferences(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            if let statusCode = response.response?.statusCode {
            SnapXEatsLoginHelper.shared.setNotAFirstTimeUser()
            self?.userPreferenceResult(code: statusCode)
            } else {
                self?.output?.response(result: NetworkResult.noInternet)
            }
        }
    }
    
    func updateUserPreferences(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPutRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            if let statusCode = response.response?.statusCode {
                self?.userPreferenceResult(code: statusCode)
            } else {
                self?.output?.response(result: NetworkResult.noInternet)
            }
        }
    }
}

extension UserPreferenceInteractor: UserPreferenceObjectMapper {
    
    func userPreferenceResult(code: Int) {
         code == 200 ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
    
}
