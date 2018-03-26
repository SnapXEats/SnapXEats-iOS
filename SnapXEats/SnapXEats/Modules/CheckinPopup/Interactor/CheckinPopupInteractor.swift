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
        let parameters: [String : Any] = [CheckinAPIInputKeys.restaurant_info_id:restaurant_id,
                                          CheckinAPIInputKeys.reward_type: RewardPointTypes.restaurant_check_in]
        checkinIntoRestaurant(forPath: path, withParameters: parameters)
    }
}

extension CheckinPopupInteractor: CheckinPopupWebService {
    func checkinIntoRestaurant(forPath: String, withParameters: [String: Any]) {
        
        SnapXEatsApi.snapXPostRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DataResponse<RewardPoints>) in
            let checkinReardPoints = response.result
            self?.mapCheckinIntoRestaurantResult(data: checkinReardPoints)
        }
    }
}

extension CheckinPopupInteractor: CheckinPopupObjectMapper {
    func mapCheckinIntoRestaurantResult(data: Result<RewardPoints>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}
