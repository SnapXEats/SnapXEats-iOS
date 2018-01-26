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
    var imageName: String
}

class FoodCardsViewController: BaseViewController, StoryboardLoadable {

    // MARK: Constants
    private let foodCardNibName = "FoodCardView"
    
    var presenter: FoodCardsPresentation?
    @IBOutlet weak var kolodaView: KolodaView!
    
    //TO DO: This is Temp Code and should be removed when API is implemented
    var foodCards = [
        FoodCard(name: "Food Card 1", imageName: "foodCard1.jpg"),
        FoodCard(name: "Food Card 2", imageName: "foodCard2.jpg"),
        FoodCard(name: "Food Card 3", imageName: "foodCard3.jpg"),
        FoodCard(name: "Food Card 4", imageName: "foodCard4.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        customizeNavigationItem()
    }
    
    //TODO: We can make this method comman for all NavigationItems if same UI is needed
    private func customizeNavigationItem() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem?.title = nil
        
        // Navigation Title Logo
        let titleLogoImage = UIImageView(frame: CGRect(x:0, y:0, width: 134, height: 30))
        titleLogoImage.contentMode = .scaleAspectFit
        titleLogoImage.image = UIImage(named: SnapXEatsImageNames.navigationLogo)
        self.navigationItem.titleView = titleLogoImage
        
        // Left Button - Menu
        let menuButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 18))
        menuButton.setImage(UIImage(named: SnapXEatsImageNames.navigationMenu), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: UIControlEvents.touchUpInside)
        let menuBarButton : UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
        // Right Button - Search
        let serarchButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        serarchButton.setImage(UIImage(named: SnapXEatsImageNames.navigationSearch), for: UIControlState.normal)
        serarchButton.addTarget(self, action: #selector(serarchButtonTapped), for: UIControlEvents.touchUpInside)
        let rightBarButton : UIBarButtonItem = UIBarButtonItem(customView: serarchButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func menuButtonTapped() {
        //Menu Button Action
    }
    
    @objc func serarchButtonTapped() {
        //Search Button Action
    }
}

extension FoodCardsViewController: FoodCardsView {
    func initView() {
        
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
