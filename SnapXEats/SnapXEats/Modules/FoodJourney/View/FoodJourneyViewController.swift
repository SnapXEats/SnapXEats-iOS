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
    @IBOutlet weak var foodJourneyTableView: UITableView!
    
    // MARK: Properties

    var presenter: FoodJourneyPresentation?
    var foodJourneyItems = [FoodJourney]()
    var currentWeekHistoryItems = [UserCurrentWeekHistory]()
    var userPastHistoryItems = [UserPastHistory]()
    fileprivate var contentHeights = [CGFloat]() // Used for storing dynamic heights of recent food journey
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendFoodJourneyRequest()
    }
    
    private func initContentHeight() {
        contentHeights.removeAll()
        for _ in currentWeekHistoryItems {
            contentHeights.append(CellHeight.defaultRecentFoodJourneyCellHeight)
        }
    }
    
    private func sendFoodJourneyRequest() {
        if checkRechability() && !isProgressHUD {
            showLoading()
            presenter?.getFoodJourneyData()
        }
    }
    
    override func success(result: Any?) {
        if let result = result as? FoodJourney {
            if let userCurrentWeekHistory = result.userCurrentWeekHistory {
                currentWeekHistoryItems = userCurrentWeekHistory
                initContentHeight()
            }
            if let userPastHistory = result.userPastHistory {
                userPastHistoryItems = userPastHistory
            }
            foodJourneyTableView.reloadData()
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
        foodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyTableView)
        
        nib = UINib(nibName: SnapXEatsNibNames.olderHeaderTableViewCell, bundle: nil)
        foodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.olderHeaderTableView)
        
        nib = UINib(nibName: SnapXEatsNibNames.olderFoodJourneyTableViewCell, bundle: nil)
        foodJourneyTableView.register(nib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.olderFoodJourneyTableView)
    }
    
    // TODO: implement view output methods
}

extension FoodJourneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentWeekHistoryItems.count
        } else if section == 1 {
            return userPastHistoryItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 1 && userPastHistoryItems.count > 0 {
            let headerView = UIView()
            let headerLabel = UILabel(frame: CGRect(x: HeaderLabel.x, y: HeaderLabel.y, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.font = UIFont(name: Constants.Font.roboto_bold, size: Constants.FontSize.OlderFoodJourneyHeader)
            headerLabel.textColor = UIColor.headerCell
            headerLabel.text = "Older"
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return CellHeight.defaulfOlderHeaderCellHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return contentHeights[indexPath.row]
        } else if indexPath.section == 1 {
            return CellHeight.defaultOlderFoodJourneyCellHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.recentFoodJourneyTableView, for: indexPath) as! RecentFoodJourneyTableViewCell
            cell.delegate = self
            cell.configureRecentFoodJourneyCell(indexPath:indexPath, item:currentWeekHistoryItems[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.olderFoodJourneyTableView, for: indexPath) as! OlderFoodJourneyTableViewCell
                cell.configureOlderFoodJourneyCell(item:userPastHistoryItems[indexPath.row])
                return cell
        }
        return UITableViewCell()
    }
}

extension FoodJourneyViewController:RecentFoodJourneyCellDelegate {
    func updateRecentFoodJourneyCellHeight(indexPath: IndexPath, estimatedHeight: CGFloat) {
        contentHeights[indexPath.row] = estimatedHeight
        self.foodJourneyTableView.beginUpdates()
        self.foodJourneyTableView.endUpdates()
    }
}
