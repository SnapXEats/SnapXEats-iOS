//
//  SavedLocationTableViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class SavedLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureSavedAddressCell(savedAddress: SavedAddress) {
        titleLabel.text = savedAddress.tilte
        addressLabel.text = savedAddress.address
        addressImageView.image = UIImage(named:savedAddress.imageName)
    }
}
