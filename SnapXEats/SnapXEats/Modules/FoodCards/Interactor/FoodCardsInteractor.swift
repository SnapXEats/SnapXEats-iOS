//
//  FoodCardsInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class FoodCardsInteractor {

    // MARK: Properties

    var output: FoodCardsInteractorOutput?
    private init() {}
    static let singleInstance = FoodCardsInteractor()
}

extension FoodCardsInteractor: FoodCardsRequestFomatter {
    func sendFoodCardRequest(selectedPreference: SelectedPreference) {
        let loginPreference = selectedPreference.loginUserPreference
        let paraMeter = loginPreference.isLoggedIn ? createParameterLoggedInUser () : createParameterNonLoggedInUser()
        getFoodCardDishesRequest(forPath: SnapXEatsWebServicePath.dishesURL, withParameters: paraMeter)
    }
    
    private func createParameterLoggedInUser() -> [String: Any] {
        return PreferenceHelper.shared.createParameterLoggedInUser()
    }
    
    private func createParameterNonLoggedInUser() -> [String: Any] {
         return PreferenceHelper.shared.createParameterNonLoggedInUser()
    }
    
    func sendUserGestures(gestures: [String: Any]) {
        sendUserGesturesRequest(forPath: SnapXEatsWebServicePath.userGesture, withParameters: gestures)
    }
}

extension FoodCardsInteractor: FoodCardsWebService {
    func getFoodCardDishesRequest(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self](response: DataResponse<DishInfo>) in
            let foodCardsResult = response.result
            self?.restaurantsDetail(data: foodCardsResult)
        }
    }
    
    func sendUserGesturesRequest(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
                self?.userGesturesResult(result: response.isSuccess)
        }
    }
}

extension FoodCardsInteractor: FoodCardsObjectMapper {    

    // TODO: Implement use case methods
    func restaurantsDetail(data: Result<DishInfo>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
        output?.response(result: NetworkResult.noInternet)
        }
    }
    
    func userGesturesResult(result: Bool) {
        result ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
}



