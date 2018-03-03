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
        let requestParameter = PreferenceHelper.shared.getJSONDataUserPrefernce()
        sendUserPreferences(forPath:SnapXEatsWebServicePath.userPreferene, withParameters: requestParameter)
    }
    
    func updateUserPreference(preference: LoginUserPreferences) {
        PreferenceHelper.shared.saveUserPrefernce(preference: preference)
        let requestParameter = PreferenceHelper.shared.getJSONDataUserPrefernce()
        updateUserPreferences(forPath: SnapXEatsWebServicePath.userPreferene, withParameters: requestParameter)
    }
    
}

extension UserPreferenceInteractor: UserPreferenceWebService {
    
    func sendUserPreferences(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            let result = response.isSuccess
            if  result {
                SnapXEatsLoginHelper.shared.setNotAFirstTimeUser()
                
            }
            self?.userPreferenceResult(result: result)
        }
    }
        
        func updateUserPreferences(forPath: String, withParameters: [String: Any]) {
            SnapXEatsApi.snapXPutRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
                self?.userPreferenceResult(result: response.isSuccess)
            }
        }
    }
    
    extension UserPreferenceInteractor: UserPreferenceObjectMapper {
        
        func userPreferenceResult(result: Bool) {
            result ? output?.response(result: .success(data: true))
                : output?.response(result: NetworkResult.noInternet)
            
        }
}
