//
//  RestaurantDetailsContract.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import Alamofire

protocol RestaurantDetailsView: BaseView {
    var presenter: RestaurantDetailsPresentation? {get set}

}

protocol RestaurantDetailsPresentation: class {
    func restaurantDetailsRequest(restaurantId: String)
    func drivingDirectionsRequest(origin: String, destination: String)
    func gotoRestaurantDirections(restaurantDetails: RestaurantDetails, parent: UINavigationController)
    func saveSmartPhoto(smartPhoto: SmartPhoto)
    func checkSmartPhoto(smartPhotoID: String) -> Bool
    func checkInternet() -> Bool

}

protocol RestaurantDetailsUseCase: class {
    // TODO: Declare use case methods
}

protocol RestaurantDetailsInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol RestaurantDetailsWireframe: class, RootWireFrame {
    func checkInternet() -> Bool

    
}

protocol RestaurantDetailsRequestFormatter: class {
    func getRestaurantDetailsRequest(restaurant_id: String)
    func getDrivingDirectionsFor(origin: String, destination: String)
    func storeSmartPhoto(smartPhoto: SmartPhoto)
    func alreadyExistingSmartPhoto(smartPhotoID: String) -> Bool
}

protocol RestaurantDetailsWebService: class {
    func getRestaurantDetails(forPath: String)
    func getDrivingDirectionsRequest(forPath: String)
}

protocol RestaurantDetailsObjectMapper: class {
    func restaurantDetails(data: Result<RestaurantDetailsItem>)
    func drivingDirectionDetails(data: Result<DrivingDirections>)
}
