//
//  WishlistItemTableViewCell.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class WishlistItemTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var wishlistItemImageView: UIImageView!
    @IBOutlet var wishlistItemName: UILabel!
    @IBOutlet var wishlistItemCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.fullShadow(color: UIColor.rgba(202.0, 202.0, 202.0, 1), offSet: CGSize(width: 0, height: 0))
    }
}
