//
//  RestaurantDirectionsViewController.swift
//  SnapXEats
//
//  Created by synerzip on 28/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDirectionsViewController: BaseViewController, StoryboardLoadable {

    private let locationTitleLeftInsetMargin: CGFloat = 15.0
    private let locationTitleTopInset: CGFloat = 5
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var timingsButton: UIButton!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantAddressLabel: UILabel!
    @IBOutlet var pricingLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    var presenter: RestaurantDirectionsPresentation?
    var restaurantDetails: RestaurantDetails!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRestaurantDetails()
    }
    
    private func showRestaurantDetails() {
        restaurantNameLabel.text = restaurantDetails.name ?? ""
        restaurantAddressLabel.text = restaurantDetails.address ?? ""
        timingsButton.setTitle(restaurantDetails.timingDisplayText(), for: .normal)
        timingsButton.titleLabel?.sizeToFit()
        let leftInset = (timingsButton.titleLabel?.frame.size.width)! + locationTitleLeftInsetMargin
        timingsButton.imageEdgeInsets = UIEdgeInsetsMake(locationTitleTopInset, leftInset, 0, -leftInset)
        ratingLabel.text = "\(restaurantDetails.rating ?? 0.0)"
        if let price = restaurantDetails.price {
            pricingLabel.text = "\(PricingPreference(rawValue: price)?.displayText() ?? "")"
        }
    }
    
    private func addShareButtonOnNavigationItem() {
        let shareButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        shareButton.setImage(UIImage(named: SnapXEatsImageNames.share), for: UIControlState.normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    @objc func shareButtonAction() {
        //Share Button Action
    }
}

extension RestaurantDirectionsViewController: RestaurantDirectionsView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.directions, isDetailPage: true)
        ratingView.layer.cornerRadius = ratingView.frame.width/2
        addShareButtonOnNavigationItem()
    }
}
