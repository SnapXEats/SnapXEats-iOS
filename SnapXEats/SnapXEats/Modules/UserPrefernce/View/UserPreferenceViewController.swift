//
//  UserPreferenceViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import BetterSegmentedControl

class UserPreferenceViewController: BaseViewController, StoryboardLoadable {

    enum filterColors {
        static let textColor = UIColor.rgba(157.0, 157.0, 163.0, 1.0)
        static let selectedTextColor = UIColor.rgba(86.0, 86.0, 86.0, 1.0)
    }
    
    var presenter: UserPreferencePresentation?
    var selectedRating:RatingPreferences = .threeStar
    var selectedPrice:PricingPreference = .single
    var sortByFilter: SortByPreference = .distance
    var selectedDistance = 0


    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var locationInfoView: UIView!
    @IBOutlet weak var pricingFilter: BetterSegmentedControl!
    @IBOutlet weak var distanceFilter: BetterSegmentedControl!
    
    @IBOutlet weak var distanceRadioButton: UIButton!
    @IBOutlet weak var ratingsRadioButton: UIButton!
    
    @IBOutlet weak var fiveStarRatingButton: UIButton!
    @IBOutlet weak var fourStarRatingButton: UIButton!
    @IBOutlet weak var threeStarRatingButton: UIButton!
    
    @IBOutlet weak var distanceRangeContainerView: UIView!
    @IBOutlet weak var priceRangeContainerView: UIView!
    
    @IBOutlet weak var selectCuisineButton: UIButton!
    @IBOutlet weak var selectFoodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        locationInfoView.addViewBorderWithColor(color: UIColor.rgba(230.0, 230.0, 230.0, 1.0), width: 1.0, side: .bottom)
    }
    
    @IBAction func applyButtonAction(_: Any) {
        // Apply Button Action
        SelectedPreference.shared.ratingPreference = selectedRating
        SelectedPreference.shared.pricingPreference = selectedPrice
        SelectedPreference.shared.sortByPreference = sortByFilter
        SelectedPreference.shared.distancePreference = selectedDistance
    }
    
    @IBAction func locationSelectAction(sender: UIButton) {
        // Location Select Action
    }
        
    @IBAction func radioButtonSelected(sender: UIButton) {
        if sender == distanceRadioButton && sender.isSelected == false {
            sender.isSelected = true
            sortByFilter = .distance
            ratingsRadioButton.isSelected = false
        }
        
        if sender == ratingsRadioButton && sender.isSelected == false {
            sender.isSelected = true
            sortByFilter = .rating
            distanceRadioButton.isSelected = false
        }
    }
    
    @IBAction func starRatingSelected(sender: UIButton) {
        
        switch sender {
        case fiveStarRatingButton:
            sender.isSelected = true
            selectedRating = .fiveStar
            threeStarRatingButton.isSelected = false
            fourStarRatingButton.isSelected = false
            
        case fourStarRatingButton:
            sender.isSelected = true
            selectedRating = .fourStar
            threeStarRatingButton.isSelected = false
            fiveStarRatingButton.isSelected = false
            
        case threeStarRatingButton:
            sender.isSelected = true
            selectedRating = .threeStar
            fourStarRatingButton.isSelected = false
            fiveStarRatingButton.isSelected = false
            
        default: break
        }
    }
}

extension UserPreferenceViewController: UserPreferenceView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsMenuOptions.preferences, isDetailPage: false)
        pricingFilter.titles = [
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString
        ]
        
        distanceFilter.titles = [
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString,
            SnapXEatsAppDefaults.emptyString
        ]
        
        selectCuisineButton.addShadow(width: 0.0, height: 0.0)
        selectFoodButton.addShadow(width: 0.0, height: 0.0)
        selectFoodButton.layer.cornerRadius = 3.0
        selectCuisineButton.layer.cornerRadius = 3.0
        
        // Show first item in Filter selected byDefault
        if let button = priceRangeContainerView.viewWithTag(1) as? UIButton {
            button.setTitleColor(filterColors.selectedTextColor, for: .normal)
        }
        
        if let button = distanceRangeContainerView.viewWithTag(1) as? UIButton {
            button.setTitleColor(filterColors.selectedTextColor, for: .normal)
        }
    }

    // TODO: implement view output methods
}

// Pricing and Distance filter and related methods
extension UserPreferenceViewController {
    
    @IBAction func pricingSelectedAction(sender: UIButton) {
        do {
            try pricingFilter.setIndex(UInt(sender.tag - 1), animated: true)
        } catch {
            print("Error in Setting Index for Price filter")
        }
    }
    
    @IBAction  func priceFilterValueChanged(_ sender: BetterSegmentedControl) {
        let buttonTag = Int(sender.index) + 1 // Tag starts from 1 to avoid confusion with other subviews of the view
        selectedPrice = PricingPreference(rawValue: buttonTag) ?? .single
        for index in 1...pricingFilter.titles.count {
            if let button = priceRangeContainerView.viewWithTag(index) as? UIButton {
                button.setTitleColor(titleColorForFilterRangeAt(index: index, buttonTag: buttonTag), for: .normal)
            }
        }
    }
    
    @IBAction func DistanceSelectedAction(sender: UIButton) {
        do {
            try distanceFilter.setIndex(UInt(sender.tag-1), animated: true)
        } catch {
            print("Error in Setting Index for Distance filter")
        }
    }
    
    @IBAction  func distanceFilterValueChanged(_ sender: BetterSegmentedControl) {
        let buttonTag = Int(sender.index) + 1 // Tag starts from 1 to avoid confusion with other subviews of the view
        selectedDistance = Int(sender.index)
        for index in 1...distanceFilter.titles.count {
            if let button = distanceRangeContainerView.viewWithTag(index) as? UIButton {
                button.setTitleColor(titleColorForFilterRangeAt(index: index, buttonTag: buttonTag), for: .normal)
            }
        }
    }
    
    private func titleColorForFilterRangeAt(index: Int, buttonTag: Int) -> UIColor {
        return (index == buttonTag) ? filterColors.selectedTextColor : filterColors.textColor
    }
}
