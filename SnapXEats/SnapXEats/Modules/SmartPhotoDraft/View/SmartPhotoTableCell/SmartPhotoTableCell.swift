//
//  SmartPhotoTableCell.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoTableCell: UITableViewCell {
    @IBOutlet weak var smartPhotoImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow()
        self.frame.size.width = 280
    }
}
