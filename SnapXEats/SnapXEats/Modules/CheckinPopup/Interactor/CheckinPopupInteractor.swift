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
    
    func getNearbyRestaurantRequest(latitude: String, longitude: String) {
        let path = SnapXEatsWebServicePath.getRestaurants
        let parameters: [String : Any] = [RestaurantListAPIKeys.latitude:latitude,
                                          RestaurantListAPIKeys.longitude: longitude]
        getNearbyRestaurants(forPath: path, withParameters: parameters)
    }
}

extension CheckinPopupInteractor: CheckinPopupWebService {
    func checkinIntoRestaurant(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXPostRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self] (response: DataResponse<RewardPoints>) in
            LoginUserPreferences.shared.isLoggedIn ? self?.checkRewardsPoints(rewardPointsEarned: response.result)
                                                   : self?.mapCheckinIntoRestaurantResult(data: response.result)
        }
    }
    
    func checkRewardsPoints(rewardPointsEarned: Result<RewardPoints>) {
        SnapXEatsApi.snapXGetRequestJSONWithParameters(path: SnapXEatsWebServicePath.rewardsPoint, parameters: [:]) { [weak self] data in
            if data.result.isSuccess, let response = data.result.value as? [String: Int64] {
                let  rewardsPoint = response[SnapXEatsWebServiceParameterKeys.userRewardPoint] ?? 0
                SnapXEatsLoginHelper.shared.updateRewardPoints(rewardPoints: rewardsPoint)
                self?.mapCheckinIntoRestaurantResult(data: rewardPointsEarned)
            } else {
                self?.mapCheckinIntoRestaurantResult(data: rewardPointsEarned)
            }
        }
    }
    
    func getNearbyRestaurants(forPath: String, withParameters: [String: Any]) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: withParameters) { [weak self](response: DataResponse<RestaurantsList>) in
            let restaurantList = response.result
            self?.mapRestaurantListResult(data: restaurantList)
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
    
    func mapRestaurantListResult(data: Result<RestaurantsList>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}
