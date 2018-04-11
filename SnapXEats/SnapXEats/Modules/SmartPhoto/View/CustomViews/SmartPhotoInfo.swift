//
//  AudioRecordingPopUp.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation


class SmartPhotoInfo: UIView {
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantInfoTabel: UITableView!
    weak var smartPhotoInfo: SmartPhoto?
    var moreInfo = [String]()
    
    func initView() {
        if let smartPhotoInfo  = smartPhotoInfo {
            restaurantName.text = smartPhotoInfo.restaurant_name
            restaurantAddress.text = smartPhotoInfo.restaurant_address
            moreInfo = smartPhotoInfo.restaurant_amenities
            moreInfo.count == 0 ? restaurantInfoTabel.isHidden = true : restaurantInfoTabel.reloadData()
        }
    }
    
}

extension SmartPhotoInfo: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SnapXEatsAppDefaults.amenitiesTableRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.moreInfoTableView, for: indexPath) as! MoreInfoTableViewCell
        cell.selectionStyle = .none
        cell.amenityNameLabel.text = moreInfo[indexPath.row]
        return cell
    }
}


