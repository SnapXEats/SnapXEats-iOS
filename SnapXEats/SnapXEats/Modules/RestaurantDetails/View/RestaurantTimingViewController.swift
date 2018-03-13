//
//  ESOptionsView.swift
//  ExamSoft
//
//  Created by Aditya Kulkarni on 23/08/16.
//  Copyright © 2016 ExamSoft. All rights reserved.
//

import Foundation
import UIKit

class RestaurantTimingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var timingsTableView: UITableView!
   
    // MARK: - Variables
    var timings = [RestaurantTiming]()
    fileprivate let rowHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
            configureView()
    }
    
    private func configureView() {
        timingsTableView.estimatedRowHeight = 60.0
        timingsTableView.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: - Table view delegate methods
extension RestaurantTimingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.restaurantTiming, for: indexPath) as! TimingTableViewCell
        cell.selectionStyle = .none
        cell.clockImageView.isHidden = indexPath.row == 0 ? false : true
        cell.dayLabel.text = timings[indexPath.row].day ?? SnapXEatsAppDefaults.emptyString
        cell.timeLabel.text = timings[indexPath.row].time ?? SnapXEatsAppDefaults.emptyString
        return cell
    }
}
