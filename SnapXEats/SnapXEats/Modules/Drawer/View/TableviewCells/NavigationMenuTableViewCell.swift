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
        
        // show SnapShare and Smart Photos options disabled
        let textColor = UIColor.rgba(72.0, 72.0, 72.0, 1.0)
        optionLabel.textColor = textColor
        optionLabel.text = title

    
        // Only Retrive wishlist count if it is to be shown(Only for one cell) and if User is logged
        wishlistCountView.isHidden = showCount == true && LoginUserPreferences.shared.isLoggedIn ? false : true
        wishlistCountLabel.text = showCount == true && LoginUserPreferences.shared.isLoggedIn ? "\(FoodCardActionHelper.shared.getWishlistCountForCurrentUser())" : ""
    }
}
