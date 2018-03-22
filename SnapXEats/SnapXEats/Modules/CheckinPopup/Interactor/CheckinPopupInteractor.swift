//
//  CheckinPopupInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 22/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

class CheckinPopupInteractor {

    // MARK: Properties
    var output: CheckinPopupInteractorOutput?
    static let shared = CheckinPopupInteractor()
    private init() {}
}

extension CheckinPopupInteractor: CheckinPopupRequestFormatter {
    func checkinIntoRestaurantRequest(restaurant_id: String) {
        let path = SnapXEatsWebServicePath.checkin
        let parameters: [String : Any] = ["restaurant_info_id":restaurant_id,
                                          "reward_point": 50]
        checkinIntoRestaurant(forPath: path, withParameters: parameters)
    }
}

extension CheckinPopupInteractor: CheckinPopupWebService {
    func checkinIntoRestaurant(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DefaultDataResponse) in
            self?.checkinIntoRestaurantResult(result: response.isSuccess)
        }
    }
}

extension CheckinPopupInteractor: CheckinPopupObjectMapper {
    func checkinIntoRestaurantResult(result: Bool) {
        result ? output?.response(result: .success(data: true))
            :output?.response(result: NetworkResult.noInternet)
    }
}
