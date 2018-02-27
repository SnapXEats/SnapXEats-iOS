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
    
    @IBAction func undoButtonAction(_ sender: Any) {
        kolodaView.revertAction()
        let userId = LoginUserPreferences.shared.loginUserID
        let userFoodCard = createUserFoodCardItem(fromIndex: kolodaView.currentCardIndex)
        FoodCardActions.removeFromDislikeList(foodCardItem: userFoodCard, userID: userId)
    }
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func starButtonAction(_ sender: Any) {
        kolodaView.swipe(.up)
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
        if let _ = result as? Bool {
            presenter?.getFoodCards(selectedPreferences: selectedPrefernce!)
        } else if let dishInfo = result as?  DishInfo, let restaurants = dishInfo.restaurants, restaurants.count > 0  {
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
            // Send Food Card Gestures Request First if there are any Gestures pending and then Load Food cards
            if let foodCardActions = FoodCardActions.getCurrentActionsForUser(userID: LoginUserPreferences.shared.loginUserID) {
                sendUserGesturesToServer(foodCardActions: foodCardActions)
            } else {
                presenter?.getFoodCards(selectedPreferences: selectedPrefernce!)
            }
        }
    }

    private func sendUserGesturesToServer(foodCardActions: FoodCardActions) {
        let gestureParameters = FoodCardActionHelper.shared.getJSONDataForGestures(foodCardActions: foodCardActions)
        presenter?.sendUserGestures(gestures: gestureParameters)
    }
    
    private func rightSwipeActionForIndex(index: Int) {
        //Add FoodCard to Liked items List
        let userId = LoginUserPreferences.shared.loginUserID
        let userFoodCard = createUserFoodCardItem(fromIndex: index)
        FoodCardActions.addToLikedList(foodCardItem: userFoodCard, userID: userId)
        
        // Goto Restaurant Details page with selected Foodcard
        let currentFoodCard = foodCards[index]
        gotoRestaurantDetailsForFoodCard(foodCard: currentFoodCard)
    }
    
    private func leftSwipeActionForIndex(index: Int) {
        //Add FoodCard to DisLiked items List
        let userId = LoginUserPreferences.shared.loginUserID
        let userFoodCard = createUserFoodCardItem(fromIndex: index)
        FoodCardActions.addToDisLikedList(foodCardItem: userFoodCard, userID: userId)
    }
    
    private func upSwipeActionForIndex(index: Int) {
        //Add FoodCard to Wishlist
        let userId = LoginUserPreferences.shared.loginUserID
        let userFoodCard = createUserFoodCardItem(fromIndex: index)
        FoodCardActions.addToWishList(foodCardItem: userFoodCard, userID: userId)
    }
    
    private func gotoRestaurantDetailsForFoodCard(foodCard: FoodCard) {
        // Restaurant Detail Action
        if let parent = self.navigationController {
            let selectedRestaurant = foodCard.restaurant
            presenter?.gotoRestaurantDetails(selectedRestaurant: selectedRestaurant, parent: parent)
        }
    }
    
    private func createUserFoodCardItem(fromIndex index: Int) -> UserFoodCard {
        let currentFoodCard = foodCards[index]
        let foodCard = UserFoodCard()
        foodCard.Id = currentFoodCard.id
        return foodCard
    }
}
