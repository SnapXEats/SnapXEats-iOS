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
    var selectedRating:RatingPreferences?
    var selectedPrice:PricingPreference = .auto
    var sortByFilter: SortByPreference = .distance
    var selectedDistance = 1
    
    @IBOutlet weak var sampleLabel: UILabel!
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
    
    let loginUserPreference = LoginUserPreferences.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidLoad()
        saveChanges()
    }
    
    @IBAction func applyButtonAction(_: Any) {
        // Apply Button Action
        if  loginUserPreference.isDirtyPreference {
            saveChanges()
            if loginUserPreference.isLoggedIn {
                if  checkRechability() {
                    showLoading()
                    loginUserPreference.firstTimeUser ? presenter?.sendUserPreference(preference: loginUserPreference)
                        : presenter?.updateUserPreference(preference: loginUserPreference)
                }
            } else {
                loginUserPreference.isDirtyPreference = false
                presentNextScreen()
            }
        } else {
            presentNextScreen()
        }
    }
    
    private func presentNextScreen() {
        if let parentNVController = self.navigationController {
            presenter?.presnetScreen(screen: .location, parent: parentNVController)
        }
    }
    
    @IBAction func radioButtonSelected(sender: UIButton) {
        if sender == distanceRadioButton && sender.isSelected == false {
            loginUserPreference.isDirtyPreference = true
            setButtonState(sortByPreference: .distance)
        }
        
        if sender == ratingsRadioButton && sender.isSelected == false {
            loginUserPreference.isDirtyPreference = true
            setButtonState(sortByPreference: .rating)
        }
    }
    
    @IBAction func selectPreferencesAction(sender: UIButton) {
        saveChanges()
        presenter?.saveUserPreference(loginUserPreferences: loginUserPreference)
        if let preferenceType = PreferenceType(rawValue: sender.tag), let parentNVController = self.navigationController {
            presenter?.presentFoodAndCuisinePreferences(preferenceType: preferenceType, parent: parentNVController)
        }
    }
    
    @IBAction func starRatingSelected(sender: UIButton) {
        switch sender {
        case fiveStarRatingButton:
            loginUserPreference.isDirtyPreference = true
            setButtonState(ratingPreferences: .fiveStar)
            
        case fourStarRatingButton:
            loginUserPreference.isDirtyPreference = true
            setButtonState(ratingPreferences: .fourStar)
            
        case threeStarRatingButton:
            loginUserPreference.isDirtyPreference = true
            setButtonState(ratingPreferences: .threeStar)
            
        default: break
        }
    }
    
    private func  setButtonState(ratingPreferences: RatingPreferences) {
        switch ratingPreferences {
        case .fiveStar:
            selectedRating = .fiveStar
            threeStarRatingButton.isSelected = false
            fourStarRatingButton.isSelected = false
            fiveStarRatingButton.isSelected = true
            
        case .fourStar:
            selectedRating = .fourStar
            threeStarRatingButton.isSelected = false
            fiveStarRatingButton.isSelected = false
            fourStarRatingButton.isSelected = true
            
        case .threeStar:
            selectedRating = .threeStar
            fourStarRatingButton.isSelected = false
            fiveStarRatingButton.isSelected = false
            threeStarRatingButton.isSelected = true
            
        }
    }
    
    private func setButtonState(sortByPreference: SortByPreference) {
        switch sortByPreference {
        case .distance:
            sortByFilter = .distance
            distanceRadioButton.isSelected = true
            ratingsRadioButton.isSelected = false
        case .rating:
            sortByFilter = .rating
            distanceRadioButton.isSelected = false
            ratingsRadioButton.isSelected = true
        }
    }
    private func saveChanges() {
        loginUserPreference.ratingPreference = selectedRating
        loginUserPreference.pricingPreference = selectedPrice
        loginUserPreference.sortByPreference = sortByFilter
        loginUserPreference.distancePreference = selectedDistance
    }
    
    override func success(result: Any?) {
        if let prefernce = result as? SetUserPreference,
            let rating = RatingPreferences(rawValue: prefernce.ratingPreference) ,
            let sortPrefernce = SortByPreference(rawValue: prefernce.sortByPreference) {
            setButtonState(ratingPreferences: rating)
            setButtonState(sortByPreference: sortPrefernce)
            setPriceIndex(index: prefernce.pricingPreference)
            setDistanceIndex(index: prefernce.distancePreference)
        } else if let _ = result as? Bool, let parentNVController = self.navigationController {
            loginUserPreference.isDirtyPreference = false
            presenter?.presnetScreen(screen: .location, parent: parentNVController)
        }
        
    }
}

extension UserPreferenceViewController: UserPreferenceView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.preferences, isDetailPage: false)
        pricingFilter.titles = [
            SnapXEatsAppDefaults.emptyString,
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
        getUserPrefernces()
    }
    
    func getUserPrefernces() {
        presenter?.getUserPreference(userID: loginUserPreference.loginUserID)
    }
}

// Pricing and Distance filter and related methods
extension UserPreferenceViewController {
    
    @IBAction func pricingSelectedAction(sender: UIButton) {
        loginUserPreference.isDirtyPreference = true
        setPriceIndex(index: sender.tag)
    }
    
    private func setPriceIndex(index: Int) {
        do {
            try pricingFilter.setIndex(UInt(index - 1), animated: true)
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
        loginUserPreference.isDirtyPreference = true
        setDistanceIndex(index: sender.tag)
    }
    
    private func setDistanceIndex(index: Int) {
        do {
            try distanceFilter.setIndex(UInt(index - 1), animated: true)
        } catch {
            print("Error in Setting Index for Distance filter")
        }
    }
    @IBAction  func distanceFilterValueChanged(_ sender: BetterSegmentedControl) {
        let buttonTag = Int(sender.index) + 1 // Tag starts from 1 to avoid confusion with other subviews of the view
        selectedDistance = Int(sender.index) + 1
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
