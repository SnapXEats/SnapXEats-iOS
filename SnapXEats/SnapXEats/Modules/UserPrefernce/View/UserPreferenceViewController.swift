//
//  UserPreferenceViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class UserPreferenceViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: UserPreferencePresentation?

    // MARK: Lifecycle
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var locationInfoView: UIView!
    
    @IBOutlet weak var distanceRadioButton: UIButton!
    @IBOutlet weak var ratingsRadioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        locationInfoView.addViewBorderWithColor(color: UIColor.rgba(230.0, 230.0, 230.0, 1.0), width: 1.0, side: .bottom)
    }
    
    @IBAction func applyButtonAction(_: Any) {
        // Apply Button Action
    }
    
    @IBAction func radioButtonSelected(sender: UIButton) {
        if sender == distanceRadioButton && sender.isSelected == false {
            sender.isSelected = true
            ratingsRadioButton.isSelected = false
        }
        
        if sender == ratingsRadioButton && sender.isSelected == false {
            sender.isSelected = true
            distanceRadioButton.isSelected = false
        }
    }
}

extension UserPreferenceViewController: UserPreferenceView {
    func initView() {
        self.customizeNavigationItemWithTitle(title: SnapXEatsMenuOptions.preferences)
    }
    
    // TODO: implement view output methods
}
