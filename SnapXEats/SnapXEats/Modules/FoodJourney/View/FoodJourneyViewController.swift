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

    // MARK: Outlets
    @IBOutlet weak var recentFoodJourneyTableView: UITableView!
    
    // MARK: Properties

    var presenter: FoodJourneyPresentation?
    
    // MARK: Constant
    let defaultRecentFoodJourneyCellHeight = 176
    let defaulfOlderHeaderCellHeight = 44
    let defaultOlderFoodJourneyCellHeight = 78

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
        registerCellForNib()
    }
    
    private func registerCellForNib() {
        var nib = UINib(nibName: SnapXEatsNibNames.recentFoodJourneyTableViewCell, bundle: nil)
        recentFoodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyTableView)
        
        nib = UINib(nibName: SnapXEatsNibNames.olderHeaderTableViewCell, bundle: nil)
        recentFoodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.olderHeaderTableView)
        
        nib = UINib(nibName: SnapXEatsNibNames.olderFoodJourneyTableViewCell, bundle: nil)
        recentFoodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.olderFoodJourneyTableView)
    }
    
    // TODO: implement view output methods
}

extension FoodJourneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // TODO: numberOfOlderCount + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return CGFloat(defaultRecentFoodJourneyCellHeight)
        } else if indexPath.row == 2 {
            return CGFloat(defaulfOlderHeaderCellHeight)
        } else {
            return CGFloat(defaultOlderFoodJourneyCellHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyTableView, for: indexPath) as! RecentFoodJourneyTableViewCell
            cell.configureRecentFoodJourneyCell()
            return cell
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.olderHeaderTableView, for: indexPath) as! OlderHeaderTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.olderFoodJourneyTableView, for: indexPath) as! OlderFoodJourneyTableViewCell
            cell.configureOlderFoodJourneyCell()
            return cell
        }
    }
}
