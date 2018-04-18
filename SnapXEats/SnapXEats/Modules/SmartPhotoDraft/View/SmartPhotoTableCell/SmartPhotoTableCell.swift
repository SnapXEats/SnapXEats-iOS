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
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    var  smartPhot_Draft_id : String?
    
    weak var delegate: TableCelldelegate?
    
    @IBAction func shareButtonAction(_ sender: Any) {
        delegate?.navigateScreen(id: smartPhot_Draft_id)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow()
        self.frame.size.width = 280
    }
}
