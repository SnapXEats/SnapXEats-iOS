//
//  SnapNShareSocialMediaInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import Alamofire
import ObjectMapper

class SnapNShareSocialMediaInteractor {

    var output: SnapNShareSocialMediaInteractorOutput?
    let userReview = LoginUserPreferences.shared.userDishReview
}


extension SnapNShareSocialMediaInteractor: SnapNShareSocialMediaUseCase {
    func sendFaceBookLoginRequest(view: BaseView?) {
        if  let view = view as? SnapNShareSocialMediaViewController, view.checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(publishPermissions: [.publishActions], viewController: view) { [weak self] loginResult in
                switch loginResult {
                case .failed( _):
                    self?.output?.response(result: NetworkResult.error)
                case .cancelled:
                    self?.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    SocialPlatformHelper.shared.saveSecondSocialLoginInfoAsFB(accessToken: accessToken)
                    self?.output?.response(result: .success(data: true))
                }
            }
        }
    }
}

extension SnapNShareSocialMediaInteractor: SnapNShareSocialMediaRequestFomatter {
    func uploadDishReview() {
        if let restaurantID = userReview.restaurantInfoId {
            let requestParameters: [String: Any] = [
            SnapXEatsWebServiceParameterKeys.restaurantInfoId: restaurantID,
            SnapXEatsWebServiceParameterKeys.textReview: userReview.reviewText,
            SnapXEatsWebServiceParameterKeys.rating: userReview.rating
        ]
        sendReviewRequest(path: SnapXEatsWebServicePath.shanNShare, parameters: requestParameters)
        }
    } 
}

extension SnapNShareSocialMediaInteractor: SnapNShareSocialMediaWebService {
    func sendReviewRequest(path: String, parameters: [String : Any]) {
        SnapXEatsApi.snapXPostRequestMutiPartObjectWithParameters(path: path, parameters: parameters, completionHandler: { [weak self] (response: DataResponse<SnapNShare>) in
            let review = response.result
            self?.reviewDetails(data: review)
        }) { [weak self] (error) in
            //print("Error --- \(error)")
            self?.output?.response(result: NetworkResult.error)
        }
    }
}

extension SnapNShareSocialMediaInteractor: SnapNShareSocialMediaObjectMapper {
    func reviewDetails(data: Result<SnapNShare>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}
