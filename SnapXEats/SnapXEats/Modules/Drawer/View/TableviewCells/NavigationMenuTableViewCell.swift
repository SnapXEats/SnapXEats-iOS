//
//  NavigationMenuTableViewCell.swift
//  Parkwel
//
//  Created   on 15/10/15.
//  Copyright © 2015 Saleel Karkhanis. All rights reserved.
//

import UIKit

class NavigationMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var wishlistCountView: UIView!
    @IBOutlet weak var wishlistCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(WithMenu title:String, showCount: Bool) {
        self.selectionStyle = .none
        wishlistCountView.layer.cornerRadius = 6.0
        optionLabel.text = title
        wishlistCountView.isHidden = !showCount
        
        // Only Retrive wishlist count if it is to be shown(Only for one cell)
        wishlistCountLabel.text = (showCount == true) ? "\(FoodCardActionHelper.shared.getWishlistCountForCurrentUser())" : ""
    }
}
