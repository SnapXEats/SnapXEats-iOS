//
//  FoodJourneyViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodJourneyViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: FoodJourneyPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getFoodJourneyData()
    }
    
    override func success(result: Any?) {
        if let result = result as? FoodJourney {
            
        }
    }
}

extension FoodJourneyViewController: FoodJourneyView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.foodJourney, isDetailPage: false)
    }
    
    // TODO: implement view output methods
}
