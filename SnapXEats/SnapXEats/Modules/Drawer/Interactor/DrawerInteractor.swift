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
    func wishListCount() -> Int {
        return FoodCardActionHelper.shared.getWishlistCountForCurrentUser()
    }
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
    
    func sendlogOutRequest() {
        sendlogOutRequest(path: SnapXEatsWebServicePath.logOut)
    }
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

extension DrawerInteractor: DrawerWebService {
    
    func sendlogOutRequest(path: String) {
        SnapXEatsApi.snapXGetRequestWithParameters(path: path , parameters: [:]) { [weak self](response: DefaultDataResponse) in
            let result = response.isSuccess
            if result {
                SnapXEatsLoginHelper.shared.resetData()
            }
            self?.userPreferenceResult(result: response.isSuccess)
        }
    }
    
    func sendUserPreferences(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            SnapXEatsLoginHelper.shared.setNotAFirstTimeUser()
            self?.userPreferenceResult(result: response.isSuccess)
        }
    }
    
    func updateUserPreferences(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPutRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            self?.userPreferenceResult(result: response.isSuccess)
        }
    }
}

extension DrawerInteractor: DrawerObjectMapper {
    
    func userPreferenceResult(result: Bool) {
        result ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
    
}
