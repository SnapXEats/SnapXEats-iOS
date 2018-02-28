//
//  FoodCardsContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

import UIKit

protocol FoodCardsView: BaseView {
    var presenter: FoodCardsPresentation? { set get }
    func showFoodCard()
}

protocol FoodCardsPresentation: class {
    func refreshFoodCards()
    func getFoodCards(selectedPreferences: SelectedPreference)
    func gotoRestaurantDetails(selectedRestaurant: Restaurant, parent: UINavigationController, showMoreInfo: Bool)
    func sendUserGestures(gestures: [String: Any])
}

protocol FoodCardsRequestFomatter: class {
    func sendFoodCardRequest(selectedPreference: SelectedPreference)
    func sendUserGestures(gestures: [String: Any])
}

protocol FoodCardsWebService: class {
     func getFoodCardDishesRequest(forPath: String, withParameters: [String: Any])
    func sendUserGesturesRequest(forPath: String, withParameters: [String: Any])
}

protocol FoodCardsObjectMapper: class {
    func restaurantsDetail(data: Result<DishInfo> )
    func userGesturesResult(code: Int)
    
}

protocol FoodCardsInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol FoodCardsWireframe: class, RootWireFrame {
     func loadFoodCardModule() -> FoodCardsViewController
}
