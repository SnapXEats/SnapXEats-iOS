//
//  WishlistInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

class WishlistInteractor {

    static let shared = WishlistInteractor()
    private init() {}
    
    // MARK: Properties

    var output: WishlistInteractorOutput?
}


extension WishlistInteractor: WishlistRequestFormatter, WishlistUseCase {
    func getWishListRestaurantDetails()  {
        sendUserWishList()
    }
    
    internal func sendUserWishList() {
        if let foodActions = FoodCardActionHelper.shared.getCurrentActionsForUser() {
            let parameters = FoodCardActionHelper.shared.getJSONDataForGestures(foodCardActions: foodActions)
            sendUserGesturesRequest(forPath: SnapXEatsWebServicePath.userGesture, withParameters: parameters) { [weak self] response in
                if response.isSuccess {
                    self?.sendWishListDetailsRequest(path: SnapXEatsWebServicePath.wishList)
                } else {
                    self?.output?.response(result: NetworkResult.noInternet)
                }
            }
        }
    }
}

extension WishlistInteractor: WishlistWebService {
    func sendWishListDetailsRequest(path: String) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: path, parameters: [:]) { [weak self] (response: DataResponse<WishList>) in
            let wishListDetails = response.result
            self?.wishListDetails(data: wishListDetails)
        }
    }
    
    func sendUserGesturesRequest(forPath: String, withParameters: [String: Any], completionHandler: @escaping (_ response: DefaultDataResponse) -> ()) {
        SnapXEatsApi.snapXPostRequestWithParameters(path: forPath, parameters: withParameters) {(response: DefaultDataResponse) in
            completionHandler(response)
        }
    }
}

extension WishlistInteractor: WishlistObjectMapper {
    func wishListDetails(data: Result<WishList>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}
