//
//  RestaurantDetailsInteractor.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import Alamofire

class RestaurantDetailsInteractor {

    // MARK: Properties
    var output: RestaurantDetailsInteractorOutput?
    
    private init() {}
    static let shared = RestaurantDetailsInteractor()
}

extension RestaurantDetailsInteractor: RestaurantDetailsRequestFormatter {
    func alreadyExistingSmartPhoto(smartPhotoID: String) -> Bool {
        return  SmartPhotoHelper.shared.hasSmartPhoto(smartPhotoDishId: smartPhotoID)
    }
    
    func getRestaurantDetailsRequest(restaurant_id: String) {
        let path = SnapXEatsWebServicePath.restaurantDetails + "/" + restaurant_id
        getRestaurantDetails(forPath: path)
    }
    
    func getDrivingDirectionsFor(origin: String, destination: String) {
        let path = String(format: SnapXEatsDirectionConstants.directionApiUrl, SnapXEatsDirectionConstants.apiKey, origin, destination)
        getDrivingDirectionsRequest(forPath: path)
    }
}

extension RestaurantDetailsInteractor: RestaurantDetailsWebService {
    func getRestaurantDetails(forPath: String) {
        SnapXEatsApi.snapXRequestObject(path: forPath) { [weak self] (response: DataResponse<RestaurantDetailsItem>) in
                let restaurantDetails = response.result
                self?.restaurantDetails(data: restaurantDetails)
        }
    }
    
    func getDrivingDirectionsRequest(forPath: String) {
        SnapXEatsApi.googleRequestObject(path: forPath) { [weak self](response: DataResponse<DrivingDirections>) in
            let drivingDirectionResult = response.result
            self?.drivingDirectionDetails(data: drivingDirectionResult)
        }
    }
}

extension RestaurantDetailsInteractor: RestaurantDetailsObjectMapper {

    func restaurantDetails(data: Result<RestaurantDetailsItem>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
    
    func drivingDirectionDetails(data: Result<DrivingDirections>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}

extension RestaurantDetailsInteractor: RestaurantDetailsUseCase {
    func storeSmartPhoto(smartPhoto: SmartPhoto) {
        SmartPhotoHelper.shared.saveSmartPhoto(smartPhoto: smartPhoto)
    }
}
