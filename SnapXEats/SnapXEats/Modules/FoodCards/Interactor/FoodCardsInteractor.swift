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
    func sendFoodCardRequest(selectedPreferences: SelectedPreference) {
        // For testing this values are hardcoded
        let lat =  NSDecimalNumber(floatLiteral: 40.4862157)
        let long = NSDecimalNumber(floatLiteral: -74.4518188)
        let requestParameter: [String: Any] = [
            SnapXEatsFoodCardInfoKeys.latitude  : lat.decimalValue, //selectedPreferences?.location.latitude ?? 0.0,
            SnapXEatsFoodCardInfoKeys.longitude : long.decimalValue,// selectedPreferences?.location.longitude ?? 0.0,
            SnapXEatsFoodCardInfoKeys.cuisineArray : selectedPreferences.selectedCuisine
        ]
        getFoodCardDishesRequest(forPath: SnapXEatsWebServicePath.dishesURL, withParameters: requestParameter)
    }
}

extension FoodCardsInteractor: FoodCardsWebService {
    func getFoodCardDishesRequest(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self](response: DataResponse<DishInfo>) in
            let foodCardsResult = response.result
            self?.restaurantsDetail(data: foodCardsResult)
        }
    }
}

extension FoodCardsInteractor: FoodCardsObjectMapper {

    // TODO: Implement use case methods
    func restaurantsDetail(data: Result<DishInfo>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _): break
        output?.response(result: NetworkResult.noInternet)
        }
    }

}



