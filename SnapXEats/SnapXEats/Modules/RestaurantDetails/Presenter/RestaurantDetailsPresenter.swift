//
//  RestaurantDetailsPresenter.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import UIKit

class RestaurantDetailsPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: RestaurantDetailsView?
    var router: RestaurantDetailsWireframe?
    var interactor: RestaurantDetailsRequestFormatter?
    
    private init() {}
    static let shared = RestaurantDetailsPresenter()
}

extension RestaurantDetailsPresenter: RestaurantDetailsPresentation {
    func presentView(view: SmartPhotView) {
        router?.presentSmartPhotoView(view: view)
    }
    
    func showSuccess() {
        router?.presentSmartPhotoView(view: .success)
    }

    
    func presentScreen(screen: Screens) {
        router?.presentScreen(screen: screen)
    }
    
    func saveSmartPhoto(smartPhoto: SmartPhoto) {
        interactor?.storeSmartPhoto(smartPhoto: smartPhoto)
    }
    
    func checkSmartPhoto(smartPhotoID: String) -> Bool {
        if let interactor = interactor {
            return interactor.alreadyExistingSmartPhoto(smartPhotoID: smartPhotoID)
        }
        return false
    }
    
    
    func restaurantDetailsRequest(restaurantId: String) {
        interactor?.getRestaurantDetailsRequest(restaurant_id: restaurantId)
    }
    
    func drivingDirectionsRequest(origin: String, destination: String) {
        interactor?.getDrivingDirectionsFor(origin: origin, destination: destination)
    }
    
    func gotoRestaurantDirections(restaurantDetails: RestaurantDetails, parent: UINavigationController) {
        router?.presentScreen(screen: .restaurantDirections(details: restaurantDetails, parentController: parent))
    }
}

extension RestaurantDetailsPresenter: RestaurantDetailsInteractorOutput {
    // TODO: implement interactor output methods
}
