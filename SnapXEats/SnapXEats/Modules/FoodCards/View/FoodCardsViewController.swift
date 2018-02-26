//
//  FoodCardsViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import Koloda

struct FoodCard {
    var id: String
    var name: String
    var imageURL: String
    var restaurant: Restaurant
}

class FoodCardsViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Constants
    var selectedPrefernce: SelectedPreference?
    var presenter: FoodCardsPresentation?
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    private var locationEnabled: Bool {
        get {
            guard let selectedPreference = selectedPrefernce else {
               return false
            }
             return (selectedPreference.location.latitude != 0.0 && selectedPreference.location.longitude != 0.0)
        }
    }
    
    var  foodCards = [FoodCard]()
    private var loadFoodCard: Bool {
        get {
             return checkRechability() &&  foodCards.count == 0 && locationEnabled
        }
    }
    
    @IBAction func refreshScreen(_ sender: Any) {
       // presenter?.refreshFoodCards()
    }
    
    @IBAction func searchButtonAction(_: Any) {
        // Search Button Action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         registerNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         showFoodCard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unRegisterNotification()
    }
    
    @objc override func internetConnected() {
           showFoodCard()
    }
    
    override func  success(result: Any?) {
        //selectedPrefernce?.resetData() // Reset the data once request completed
        if let dishInfo = result as?  DishInfo, let restaurants = dishInfo.restaurants, restaurants.count > 0  {
            setFoodCardDetails(restaurants: restaurants)
        }
    }
    
    private func setFoodCardDetails(restaurants: [Restaurant]) {
        self.foodCards.removeAll()
        for restaurant in restaurants {
             let dishes = restaurant.restaurantDishes
                for dishitem in dishes {
                    let foodCard = FoodCard(id: dishitem.restaurant_dish_id!, name: restaurant.restaurant_name!, imageURL: dishitem.dish_image_url!, restaurant: restaurant)
                    self.foodCards.append(foodCard)
                }
        }
        kolodaView.reloadData()
         hideLoading()
    }
}

extension FoodCardsViewController: FoodCardsView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.restaurants, isDetailPage: true)
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
}

extension FoodCardsViewController: KolodaViewDelegate, KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return foodCards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let foodCardView = UINib(nibName: SnapXEatsNibNames.foodCardView, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FoodCardView
        foodCardView.setupFoodCardView(CGRect(x: 0, y: 0, width: koloda.frame.width, height: koloda.frame.height), foodCardItem: foodCards[index])
        foodCardView.addShadow()
        return foodCardView
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let currentFoodCard = foodCards[index]
        gotoRestaurantDetailsForFoodCard(foodCard: currentFoodCard)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left: leftSwipeActionForIndex(index: index)
        case .right: rightSwipeActionForIndex(index: index)
        case .up: upSwipeActionForIndex(index: index)
        default: break
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed(SnapXEatsNibNames.foodCardOverlayView, owner: self, options: nil)?[0] as? foodCardOverlayView
    }
}

extension FoodCardsViewController {
    
    func showFoodCard() {
        if loadFoodCard {
            showLoading()
            presenter?.getFoodCards(selectedPreferences: selectedPrefernce!)
        }
    }
    
    private func rightSwipeActionForIndex(index: Int) {
        let currentFoodCard = foodCards[index]
        gotoRestaurantDetailsForFoodCard(foodCard: currentFoodCard)
    }
    
    private func leftSwipeActionForIndex(index: Int) {
        // Left Swipe Action
    }
    
    private func upSwipeActionForIndex(index: Int) {
        // Up Swipe Action
        let currentFoodCard = foodCards[index]
        let userId = LoginUserPreferences.shared.loginUserID
        let foodCard = UserFoodCard()
        foodCard.Id = currentFoodCard.id
        FoodCardActions.addToWishList(foodCardItem: foodCard, userID: userId)
    }
    
    private func gotoRestaurantDetailsForFoodCard(foodCard: FoodCard) {
        // Restaurant Detail Action
        if let parent = self.navigationController {
            let selectedRestaurant = foodCard.restaurant
            presenter?.gotoRestaurantDetails(selectedRestaurant: selectedRestaurant, parent: parent)
        }
    }
}
