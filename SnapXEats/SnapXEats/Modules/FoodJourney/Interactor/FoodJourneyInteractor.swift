//
//  FoodJourneyInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

class FoodJourneyInteractor {

    // MARK: Properties

    weak var output: FoodJourneyInteractorOutput?
    private init() {}
    static let shared = FoodJourneyInteractor()
}

extension FoodJourneyInteractor: FoodJourneyUseCase {
    func sendFoodJourneyRequest() {
        requestFoodJourneyRequest(path: SnapXEatsWebServicePath.foodJourney )
    }
}

extension FoodJourneyInteractor: FoodJourneyWebService {
    func requestFoodJourneyRequest(path: String) {
         let paraMeter: [String: Any] = [:]
        SnapXEatsApi.snapXRequestObjectWithParameters(path: path, parameters: paraMeter) { [weak self](response: DataResponse<FoodJourney>) in
            let foodJourney = response.result
            self?.foodJourneyDetails(data: foodJourney)
        }
    }
}

extension FoodJourneyInteractor: FoodJourneyObjectmapper {
    func foodJourneyDetails(data: Result<FoodJourney>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
    
    
}
