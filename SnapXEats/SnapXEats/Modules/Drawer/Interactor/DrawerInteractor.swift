//
//  DrawerInteractor.swift
//  
//
//  Created by Durgesh Trivedi on 22/02/18.
//  
//

import Foundation
import ObjectMapper
import Alamofire

class DrawerInteractor {

    static let shared = DrawerInteractor()
    private init(){}
    // MARK: Properties

    var output: DrawerInteractorOutput?
}

extension DrawerInteractor: DrawerUseCase {
    // TODO: Implement use case methods
}



extension DrawerInteractor: DrawerInteractorIntput {
    
    func saveUserPreference(loginUserPreferences : LoginUserPreferences) {
        PreferenceHelper.shared.saveUserPrefernce(preference: loginUserPreferences)
    }
    
    func getUserPreference(userID: String) {
        if let prefernce = PreferenceHelper.shared.getUserPrefernce(userID: userID){
            output?.response(result: .success(data: prefernce))
        }
    }
}

extension DrawerInteractor: DrawerRequestFormatter {
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

extension DrawerInteractor: DrawerWebService {
    
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

extension DrawerInteractor: DrawerObjectMapper {
    
    func userPreferenceResult(code: Int) {
        code == 200 ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
    
}
