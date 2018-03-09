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
        sendWishListDeletedRequest()
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
    
    
    private func sendWishListDeletedRequest() {
        let parameter = FoodCardActionHelper.shared.getJSONDataDeletedWishListItems()
        if parameter.count > 0 {
            deltedWishListRequest(forPath: SnapXEatsWebServicePath.wishList, withParameters: parameter) { [weak self] response in
                if response.isSuccess {
                    FoodCardActionHelper.shared.deleteItemFromWishList()
                    self?.sendUserWishList()
                } else {
                    self?.output?.response(result: NetworkResult.noInternet)
                }
            }
        } else {
            sendUserWishList()
        }
    }
    
   private func sendUserWishList() {
        if let foodActions = FoodCardActionHelper.shared.getCurrentActionsForUser() {
            let parameters = FoodCardActionHelper.shared.getJSONDataForGestures(foodCardActions: foodActions)
            sendUserGesturesRequest(forPath: SnapXEatsWebServicePath.userGesture, withParameters: parameters) { [weak self] response in
                if response.isSuccess {
                    self?.sendlogOutRequest(path: SnapXEatsWebServicePath.logOut)
                } else {
                    self?.output?.response(result: NetworkResult.noInternet)
                }
            }
        } else {
            sendlogOutRequest(path: SnapXEatsWebServicePath.logOut)
        }
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
    
    func deltedWishListRequest(forPath: String, withParameters: [String: Any], completionHandler: @escaping (_ response: DefaultDataResponse) -> ()) {
        SnapXEatsApi.snapXDelteRequestWithParameters(path: forPath, parameters: withParameters) {(response: DefaultDataResponse) in
            completionHandler(response)
        }
    }
    
    func sendUserGesturesRequest(forPath: String, withParameters: [String: Any], completionHandler: @escaping (_ response: DefaultDataResponse) -> ()) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) {(response: DefaultDataResponse) in
            completionHandler(response)
        }
    }
    
}

extension DrawerInteractor: DrawerObjectMapper {
    
    func userPreferenceResult(result: Bool) {
        result ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
    
}
