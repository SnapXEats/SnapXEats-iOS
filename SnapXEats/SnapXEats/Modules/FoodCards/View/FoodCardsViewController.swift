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
    var name: String
    var imageURL: String
}

class FoodCardsViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Constants
    private let foodCardNibName = "FoodCardView"
    
    var selectedPrefernce = SelectedPreference()
    var presenter: FoodCardsPresentation?
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBAction func refreshScreen(_ sender: Any) {
        presenter?.refreshFoodCards()
    }
    
    @IBAction func searchButtonAction(_: Any) {
        // Search Button Action
    }
    
    //TO DO: This is Temp Code and should be removed when API is implemented
    var  foodCards = [
        FoodCard(name: "", imageURL: ""),
        FoodCard(name: "", imageURL: ""),
        FoodCard(name: "", imageURL: ""),
        FoodCard(name: "", imageURL: "")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showFoodCard()
    }
    
    override func  success(result: Any?) {
        hideLoading()
        if let restaurants = result as? [Restaurant] {
            setFoodCardDetails(restaurants: restaurants)
        }
    }
    
    private func setFoodCardDetails(restaurants: [Restaurant]) {
        hideLoading()
        for restaurant in restaurants {
             let dishes = restaurant.restaurantDishes
                for dishitem in dishes {
                    let foodCard = FoodCard(name: restaurant.restaurant_name!, imageURL: dishitem.dish_image_url!)
                    self.foodCards.append(foodCard)
                }
        }
         kolodaView.reloadData()
    }
}

extension FoodCardsViewController: FoodCardsView {
    func initView() {
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.customizeNavigationItemWithTitle()
    }
}

extension FoodCardsViewController: KolodaViewDelegate, KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return foodCards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let foodCardView = UINib(nibName: foodCardNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FoodCardView
        foodCardView.setupFoodCardView(CGRect(x: 0, y: 0, width: koloda.frame.width, height: koloda.frame.height), foodCardItem: foodCards[index])
        foodCardView.addShadow()
        return foodCardView
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // FoodCard click Action
    }
}

extension FoodCardsViewController {
    
    func showFoodCard() {
        if checkRechability() {
            showLoading()
            presenter?.getFoodCards(selectedPreferences: selectedPrefernce)
        }
    }
}
