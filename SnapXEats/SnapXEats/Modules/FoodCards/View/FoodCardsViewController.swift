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
        customizeNavigationItem()
    }
    
    
    //TODO: We can make this method comman for all NavigationItems if same UI is needed
    private func customizeNavigationItem() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem?.title = nil
        
        // Navigation Title Logo
        self.navigationItem.titleView = setTitleLogo()
        // Left Button - Menu
        self.navigationItem.leftBarButtonItem = setMenuButton()
        
        // Right Button - Search
        self.navigationItem.rightBarButtonItem = setSearchButton()
    }
    
    private func setTitleLogo() -> UIImageView {
        let titleLogoImage = UIImageView(frame: CGRect(x:0, y:0, width: 134, height: 30))
        titleLogoImage.contentMode = .scaleAspectFit
        titleLogoImage.image = UIImage(named: SnapXEatsImageNames.navigationLogo)
        return titleLogoImage
    }
    
    private func setMenuButton() -> UIBarButtonItem {
        let menuButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 18))
        menuButton.setImage(UIImage(named: SnapXEatsImageNames.navigationMenu), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: UIControlEvents.touchUpInside)
        return  UIBarButtonItem(customView: menuButton)
    }
    
    private func setSearchButton() -> UIBarButtonItem {
        let serarchButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        serarchButton.setImage(UIImage(named: SnapXEatsImageNames.navigationSearch), for: UIControlState.normal)
        serarchButton.addTarget(self, action: #selector(serarchButtonTapped), for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: serarchButton)
    }
    
    @objc func menuButtonTapped() {
        //Menu Button Action
        let router = RootRouter.singleInstance
        router.drawerController.setDrawerState(.opened, animated: true)
    }
    
    @objc func serarchButtonTapped() {
        //Search Button Action
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
