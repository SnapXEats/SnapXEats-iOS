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
    func sendFoodCardRequest(selectedPreferences: SelectedPreference?) {
        let requestParameter: [String: Any] = [
            SnapXEatsFoodCardInfoKeys.latitude : selectedPreferences?.location.latitude ?? 0.0,
            SnapXEatsFoodCardInfoKeys.longitude : selectedPreferences?.location.longitude ?? 0.0,
            SnapXEatsFoodCardInfoKeys.cuisineArray : selectedPreferences?.selectedCuisine ?? []
        ]
        getFoodCardDishesRequest(forPath: SnapXEatsWebServicePath.dishesURL, withParameters: requestParameter)
    }
}

extension FoodCardsInteractor: FoodCardsWebService {
    func getFoodCardDishesRequest(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self](response: DataResponse<FoodCards>) in
            let foodCardsResult = response.result
            self?.foodCardDetails(data: foodCardsResult)
        }
    }
}

extension FoodCardsInteractor: FoodCardsObjectMapper {
    
    // TODO: Implement use case methods
    func foodCardDetails(data: Result<FoodCards> ) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _): break
        output?.response(result: NetworkResult.noInternet)
        }
    }

}



